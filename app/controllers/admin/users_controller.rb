class Admin::UsersController < ApplicationController
  before_action :authorize_admin!
before_action :set_user, only: [:edit, :update, :destroy, :show]

  def index
  @users = User.all

  if params[:query].present?
    # Busca por nome, email ou cargo 
    @users = @users.where("name LIKE ? OR email LIKE ? OR CAST(role AS TEXT) LIKE ?", 
                          "%#{params[:query]}%", "%#{params[:query]}%", "%#{params[:query]}%")
  end
end
  def new
    @user = User.new
  end

  
  def create
    @user = User.new(user_params)
    
    # senha padrão para o primeiro acesso do morador
    senha_padrao = "senha123"
    @user.password = senha_padrao
    @user.password_confirmation = senha_padrao

    if @user.save
      redirect_to admin_users_path, notice: "Usuário #{@user.name} cadastrado com sucesso!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if params[:user][:password].blank?
      params[:user].delete(:password)
      params[:user].delete(:password_confirmation)
    end

    if @user.update(user_params)
      redirect_to admin_users_path, notice: "Usuário #{@user.name} atualizado com sucesso!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

def destroy
    if @user == current_user
      redirect_to admin_users_path, alert: "Você não pode se excluir, Cindy! O sistema precisa de um Admin."
    else
      @user.destroy
      redirect_to admin_users_path, notice: "Usuário removido com sucesso."
    end
  end

  def show
  redirect_to admin_users_path
end

  private

  def set_user
    @user = User.find(params[:id])
  end

 def user_params
 
  params.require(:user).permit(:name, :email, :password, :password_confirmation, :role, assigned_category_ids: [])
end
end