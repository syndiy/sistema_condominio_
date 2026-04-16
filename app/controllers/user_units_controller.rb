class UserUnitsController < ApplicationController
  before_action :authorize_admin!
  
  before_action :set_user_unit, only: %i[ show edit update destroy ]

  # GET /user_units or /user_units.json
  def index
    @user_units = UserUnit.all
  end

  # GET /user_units/1 or /user_units/1.json
  def show
  end

  # GET /user_units/new
  def new
    @user_unit = UserUnit.new
  end

  # GET /user_units/1/edit
  def edit
  end

  # POST /user_units or /user_units.json
  def create
    @user_unit = UserUnit.new(user_unit_params)

    respond_to do |format|
      if @user_unit.save
        format.html { redirect_to @user_unit, notice: "User unit was successfully created." }
        format.json { render :show, status: :created, location: @user_unit }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user_unit.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /user_units/1 or /user_units/1.json
  def update
    respond_to do |format|
      if @user_unit.update(user_unit_params)
        format.html { redirect_to @user_unit, notice: "User unit was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @user_unit }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user_unit.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /user_units/1 or /user_units/1.json
  def destroy
    @user_unit.destroy!

    respond_to do |format|
      format.html { redirect_to user_units_path, notice: "User unit was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_unit
      @user_unit = UserUnit.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
   def user_unit_params
  # Damos permissão para o ID do usuário e o ID da unidade
  params.require(:user_unit).permit(:user_id, :unit_id)
  end
end
