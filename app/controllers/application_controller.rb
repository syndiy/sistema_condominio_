class ApplicationController < ActionController::Base
  

  before_action :authenticate_user!

  # Bloqueia quem não é Admin
  def authorize_admin!
    unless current_user&.admin?
      redirect_to tickets_path, alert: "Acesso restrito a administradores."
    end
  end

  # Bloqueia quem não é Colaborador ou Admin (para a gestão de chamados)
  def authorize_staff!
    unless current_user&.admin? || current_user&.colaborador?
      redirect_to tickets_path, alert: "Você não tem permissão para gerenciar chamados."
    end
  end

  # Bloqueia quem não é Morador (para criar novos chamados)
  def authorize_morador!
    unless current_user&.morador?
      redirect_to tickets_path, alert: "Apenas moradores podem abrir novos chamados."
    end
  end

  protected

  def after_sign_in_path_for(resource)
    if resource.admin?
      blocks_path
    else
      tickets_path 
    end
  end
end