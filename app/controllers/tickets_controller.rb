class TicketsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_ticket, only: %i[ show edit update destroy ]
  before_action :authorize_criacao!, only: [:new, :create]
  before_action :set_unidades_disponiveis, only: [:new, :edit, :create, :update]

def index
 
  scope = Ticket.includes(:user, :unit, :ticket_type, :status)

  
  if current_user.admin?
    @tickets = scope.all
  elsif current_user.colaborador?
    
    @tickets = scope.where(ticket_type_id: current_user.assigned_category_ids)
  else
    @tickets = scope.where(user_id: current_user.id)
  end

  
  @tickets = @tickets.where(status_id: params[:status_id]) if params[:status_id].present?

  
  @tickets = @tickets.order(created_at: :desc)
end

def show
 
  @ticket = Ticket.with_attached_attachments
                  .with_attached_resolution_media
                  .find(params[:id])
end

  def new
    @ticket = Ticket.new
    # Filtra unidades: se for admin vê tudo, se for morador só as dele
    @unidades_disponiveis = current_user.admin? ? Unit.all : current_user.units
  end

  def edit
    @ticket = Ticket.find(params[:id])
    # Filtra unidades: se for admin vê tudo, se for morador só as dele
    @unidades_disponiveis = current_user.admin? ? Unit.all : current_user.units
  end

  def create
    @ticket = Ticket.new(ticket_params)
    @ticket.user = current_user if @ticket.user.nil?
    
    # Define status Aberto apenas se não vier nada do form
    if @ticket.status.nil?
      @ticket.status = Status.find_by(name: "Aberto")
    end

    # Se já criar como concluído, grava a data
    status_nome = @ticket.status&.name&.downcase || ""
    if status_nome.include?('concluido') || status_nome.include?('concluído')
      @ticket.finished_at = Time.current
    end

    if @ticket.save
      redirect_to @ticket, notice: "Chamado registrado com sucesso!"
    else
      set_unidades_disponiveis
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if ticket_params[:status_id].present?
      status_nome = Status.find(ticket_params[:status_id]).name.downcase
      if status_nome.include?('concluido') || status_nome.include?('concluído')
        @ticket.finished_at = Time.current
      end
    end

    if @ticket.update(ticket_params)
      redirect_to @ticket, notice: "Chamado atualizado com sucesso!"
    else
      set_unidades_disponiveis
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @ticket.destroy!
    redirect_to tickets_path, notice: "Chamado excluído."
  end

  private

  def set_unidades_disponiveis
    if current_user.admin?
      @unidades_disponiveis = Unit.all.includes(:block).order(:number)
    else
      @unidades_disponiveis = current_user.units.includes(:block)
    end
  end

  def authorize_criacao!
    unless current_user.morador? || current_user.admin?
      redirect_to tickets_path, alert: "Apenas moradores e admins podem abrir chamados."
    end
  end

  def set_ticket
    @ticket = Ticket.find(params[:id])
  end

def ticket_params
  
    morador_params = [:title, :description, :unit_id, :ticket_type_id, attachments: []]
    tech_params = [:status_id, :tech_notes, resolution_media: []]

    if current_user.admin?
      params.require(:ticket).permit(*(morador_params + tech_params + [:user_id]))
    elsif current_user.colaborador?
      params.require(:ticket).permit(*tech_params)
    else
      params.require(:ticket).permit(*morador_params)
    end
  end
end