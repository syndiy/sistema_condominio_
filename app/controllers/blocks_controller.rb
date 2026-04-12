class BlocksController < ApplicationController
  before_action :authenticate_user!
  # Nova trava: impede qualquer ação de quem não for Admin
  before_action :authorize_admin!
  before_action :set_block, only: %i[ show edit update destroy ]

  def index
    @blocks = Block.all
  end

  def show
  end

  def new
    @block = Block.new
  end

  def edit
  end

def create
  @block = Block.new(block_params)

  if @block.save
    # Usando parênteses para garantir que o Rails entenda o Hash do notice
    redirect_to(blocks_path, notice: "Bloco e unidades gerados com sucesso conforme o padrão!")
  else
    render(:new, status: :unprocessable_entity)
  end
end

  def update
    respond_to do |format|
      if @block.update(block_params)
        format.html { redirect_to @block, notice: "Bloco atualizado com sucesso.", status: :see_other }
        format.json { render :show, status: :ok, location: @block }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @block.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    if @block.units.any?
      redirect_to blocks_path, alert: "Ação negada: Este bloco possui #{@block.units.count} unidades cadastradas. Remova as unidades primeiro."
    else
      @block.destroy
      redirect_to blocks_path, notice: "Bloco removido com sucesso."
    end
  end

  private

  # Novo método de autorização exigido pelo PDF para gestão de estrutura
  def authorize_admin!
    unless current_user.admin?
      redirect_to root_path, alert: "Acesso negado: Apenas administradores gerenciam a estrutura física."
    end
  end

  def set_block
    @block = Block.find(params.expect(:id))
  end

  def block_params
    params.expect(block: [ :identification, :floors_count, :apartments_per_floor ])
  end
end