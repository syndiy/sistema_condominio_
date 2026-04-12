class StaticPagesController < ApplicationController
  before_action :authenticate_user!
  
  def admin_dashboard
    # Bloqueia se não for admin para garantir a regra de acesso do PDF [cite: 10, 49]
    redirect_to root_path, alert: "Acesso negado: apenas administradores." unless current_user.admin?
  end
end