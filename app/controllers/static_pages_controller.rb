class StaticPagesController < ApplicationController
  before_action :authenticate_user!
  
  def admin_dashboard
   
    redirect_to root_path, alert: "Acesso negado: apenas administradores." unless current_user.admin?
  end
end