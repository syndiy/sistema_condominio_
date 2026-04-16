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
      # Redireciona para o INDEX para o Admin ver a tabela atualizada
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
    # Use params[:id] se params.expect der erro de versão do Rails
    @status = Status.find(params[:id]) 
  end

  def status_params
    # Ajustado para o padrão comum se o expect for muito novo para seu ambiente
    params.require(:status).permit(:name)
  end
end