class StatusesController < ApplicationController
  before_action :authorize_admin!
  before_action :authenticate_user! # Garante que só logado acessa
  before_action :set_status, only: %i[ show edit update destroy ]

  def index
    @statuses = Status.all
  end

  def new
    @status = Status.new
  end

  def edit
  end

  def create
    @status = Status.new(status_params)

    if @status.save
   
      redirect_to statuses_path, notice: "Status criado com sucesso!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @status.update(status_params)
      redirect_to statuses_path, notice: "Status atualizado com sucesso!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @status.destroy!
    redirect_to statuses_path, notice: "Status removido com sucesso!", status: :see_other
  end

  private

  def set_status
   
    @status = Status.find(params[:id]) 
  end

  def status_params
   
    params.require(:status).permit(:name)
  end
end