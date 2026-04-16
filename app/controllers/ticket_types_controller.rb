class TicketTypesController < ApplicationController
  before_action :authorize_admin!
  before_action :set_ticket_type, only: %i[ show edit update destroy ]

  
  def index
    @ticket_types = TicketType.all
  end

  
  def show
  end

  
  def new
    @ticket_type = TicketType.new
  end

  
  def edit
  end

  
  def create
    @ticket_type = TicketType.new(ticket_type_params)

    respond_to do |format|
      if @ticket_type.save
        format.html { redirect_to @ticket_type, notice: "Ticket type was successfully created." }
        format.json { render :show, status: :created, location: @ticket_type }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @ticket_type.errors, status: :unprocessable_entity }
      end
    end
  end

  
  def update
    respond_to do |format|
      if @ticket_type.update(ticket_type_params)
        format.html { redirect_to @ticket_type, notice: "Ticket type was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @ticket_type }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @ticket_type.errors, status: :unprocessable_entity }
      end
    end
  end

  
  def destroy
    @ticket_type.destroy!

    respond_to do |format|
      format.html { redirect_to ticket_types_path, notice: "Ticket type was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
   
    def set_ticket_type
      @ticket_type = TicketType.find(params.expect(:id))
    end

   
    def ticket_type_params
      params.expect(ticket_type: [ :title, :sla_hours ])
    end
end
