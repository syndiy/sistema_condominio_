class UserUnitsController < ApplicationController
  before_action :authorize_admin!
  
  before_action :set_user_unit, only: %i[ show edit update destroy ]

  
  def index
    @user_units = UserUnit.all
  end

  
  def show
  end

  
  def new
    @user_unit = UserUnit.new
  end

  
  def edit
  end

  
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

 
  def destroy
    @user_unit.destroy!

    respond_to do |format|
      format.html { redirect_to user_units_path, notice: "User unit was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end


  def get_units_by_user
    @units = Unit.joins(:user_units).where(user_units: { user_id: params[:user_id] })
    render json: @units.map { |u| 
      { 
        id: u.id, 
        number: u.number, 
        block_identification: u.block.identification 
      } 
    }
  end

  private
   
    def set_user_unit
      @user_unit = UserUnit.find(params.expect(:id))
    end

   
   def user_unit_params
 
  params.require(:user_unit).permit(:user_id, :unit_id)
  end


  
end
