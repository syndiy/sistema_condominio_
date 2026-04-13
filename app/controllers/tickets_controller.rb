class TicketsController < ApplicationController
  before_action :set_ticket, only: %i[ show edit update destroy ]

  # GET /tickets or /tickets.json
def index
  if current_user.admin? || current_user.colaborador?
    @tickets = Ticket.all
    # Implementando filtro básico exigido pelo PDF 
    @tickets = @tickets.where(status_id: params[:status_id]) if params[:status_id].present?
  else
    @tickets = current_user.tickets # Morador vê apenas os seus [cite: 14]
  end
end
  # GET /tickets/1 or /tickets/1.json
  def show
  end

  # GET /tickets/new
  def new
    @ticket = Ticket.new
  end

  # GET /tickets/1/edit
  def edit
  end

  # POST /tickets or /tickets.json
def create
  @ticket = Ticket.new(ticket_params)
  
  # AQUI ESTÁ O PULO DO GATO:
  # Vinculamos o chamado diretamente ao usuário logado (o morador)
  @ticket.user = current_user 

  # Se for um morador abrindo, garantimos que comece como 'Aberto' (ou o ID do status inicial)
  @ticket.status = Status.find_by(name: "Aberto") if @ticket.status.nil?

  if @ticket.save
    redirect_to @ticket, notice: "Chamado aberto com sucesso! Agora é só aguardar o técnico."
  else
    render :new, status: :unprocessable_entity
  end
end

  # PATCH/PUT /tickets/1 or /tickets/1.json
  def update
    respond_to do |format|
      if @ticket.update(ticket_params)
        format.html { redirect_to @ticket, notice: "Ticket was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @ticket }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @ticket.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tickets/1 or /tickets/1.json
  def destroy
    @ticket.destroy!

    respond_to do |format|
      format.html { redirect_to tickets_path, notice: "Ticket was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ticket
      @ticket = Ticket.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
   def ticket_params
  # Note o 'attachments: []' no final. 
  # Ele tem que ser o ÚLTIMO da lista e estar com esses colchetes.
  params.require(:ticket).permit(:title, :description, :unit_id, :ticket_type_id, :status_id, attachments: [])
end
end
