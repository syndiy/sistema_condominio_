class TicketsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_ticket, only: %i[ show edit update destroy ]

  # GET /tickets
  def index
    if current_user.admin? || current_user.colaborador?
      @tickets = Ticket.all
      # Filtro de status para o Admin/Colaborador
      @tickets = @tickets.where(status_id: params[:status_id]) if params[:status_id].present?
    else
      @tickets = current_user.tickets # Morador vê apenas os seus
    end
  end

  # GET /tickets/1
  def show
  end

  # GET /tickets/new
  def new
    @ticket = Ticket.new
  end

  # GET /tickets/1/edit
  def edit
  end

  # POST /tickets
  def create
    @ticket = Ticket.new(ticket_params)
    
    # Se o Admin não selecionou um morador (retroativo), o dono é o próprio Admin
    # Se for morador criando, o dono é o próprio morador
    @ticket.user = current_user if @ticket.user.nil?

    # Status inicial padrão caso não venha no formulário
    @ticket.status = Status.find_by(name: "Aberto") if @ticket.status.nil?

    if @ticket.save
      redirect_to @ticket, notice: "Chamado registrado com sucesso!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /tickets/1
  def update
  # Carrega os parâmetros
  params_to_update = ticket_params.to_h

  # Se o campo veio vazio porque estava 'disabled' no HTML, removemos da atualização
  # para o Rails não apagar o que já existe no banco.
  params_to_update.delete_if { |key, value| value.blank? && ["title", "description", "unit_id", "ticket_type_id"].include?(key) }

  if ticket_params[:status_id] == "3"
    @ticket.finished_at = Time.current
  end

  if @ticket.update(params_to_update)
    redirect_to @ticket, notice: "Chamado atualizado com sucesso!"
  else
    render :edit, status: :unprocessable_entity
  end
end

  # DELETE /tickets/1
  def destroy
    @ticket.destroy!
    redirect_to tickets_path, notice: "Chamado excluído.", status: :see_other
  end

  private

  def set_ticket
    # Use params[:id] para garantir compatibilidade
    @ticket = Ticket.find(params[:id])
  end

  def ticket_params
    # AQUI ESTÁ A CHAVE: Liberamos tech_notes, user_id (retroativo) e resolution_media
    params.require(:ticket).permit(
      :title, 
      :description, 
      :unit_id, 
      :ticket_type_id, 
      :status_id, 
      :user_id, 
      :tech_notes, 
      attachments: [], 
      resolution_media: []
    )
  end
end