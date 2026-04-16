class BlocksController < ApplicationController
 
  before_action :authorize_admin!
  before_action :authenticate_user!
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
  @block = Block.find(params[:id])
  
  # Conta quantos moradores e chamados existem através das unidades do bloco
  units_ids = @block.units.pluck(:id)
  moradores_count = UserUnit.where(unit_id: units_ids).count
  chamados_count = Ticket.where(unit_id: units_ids).count

  if moradores_count > 0 || chamados_count > 0
    msg = "Não é possível excluir este bloco pois existem #{moradores_count} moradores e #{chamados_count} chamados vinculados. "
    msg += "Para deletar um bloco com dados ativos, entre em contato com a assistência técnica para evitar a perda de informações."
    
    redirect_to block_path(@block), alert: msg
  else
    @block.destroy
    redirect_to blocks_path, notice: "Bloco excluído com sucesso!"
  end
end
  private

  
def authorize_admin!
  
  unless current_user&.admin? 
    redirect_to tickets_path
  end
end
  def set_block
    @block = Block.find(params.expect(:id))
  end

  def block_params
    params.expect(block: [ :identification, :floors_count, :apartments_per_floor ])
  end
end