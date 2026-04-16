class UnitsController < ApplicationController
  before_action :authorize_admin!
  before_action :set_unit, only: %i[ show edit update destroy ]

  # GET /units or /units.json
 # app/controllers/units_controller.rb
def index
  # Mantemos o includes para performance e o order para organização
  @units = Unit.includes(:users, :block).order(:number)

  if params[:query].present?
    query = "%#{params[:query]}%"
    # Buscamos apenas no número da unidade, no nome do bloco ou no e-mail do morador
    @units = @units.joins(:block).left_outer_joins(:users).where(
      "units.number LIKE ? OR blocks.identification LIKE ? OR users.email LIKE ?", 
      query, query, query
    ).distinct
  end
end

  # GET /units/1 or /units/1.json
  def show
  end

  # GET /units/new
  def new
    @unit = Unit.new
  end

  # GET /units/1/edit
  def edit
  end

  # POST /units or /units.json
  def create
    @unit = Unit.new(unit_params)

    respond_to do |format|
      if @unit.save
        format.html { redirect_to @unit, notice: "Unit was successfully created." }
        format.json { render :show, status: :created, location: @unit }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @unit.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /units/1 or /units/1.json
  def update
    respond_to do |format|
      if @unit.update(unit_params)
        format.html { redirect_to @unit, notice: "Unit was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @unit }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @unit.errors, status: :unprocessable_entity }
      end
    end
  end

def destroy
  @unit = Unit.find(params[:id])
  
  if @unit.destroy
    redirect_to units_path, notice: "Unidade excluída com sucesso."
  else
    # Se a trava check_for_occupants disparar, ela cai aqui:
    redirect_to @unit, alert: @unit.errors.full_messages.to_sentence
  end
end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_unit
      @unit = Unit.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
   def unit_params
  # Aqui você diz ao Rails: "Pode deixar passar esses três campos específicos"
  params.require(:unit).permit(:number, :floor, :block_id)
    end
end
