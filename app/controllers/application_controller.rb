class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  def authorize_admin!
    unless current_user&.admin?
      redirect_to root_path, alert: "Acesso restrito apenas para administradores."
    end
  end


  protected

  # Este método do Devise decide para onde o usuário vai após o login
  def after_sign_in_path_for(resource)
    if resource.admin? # ou resource.role == 'admin'
      blocks_path
    else
      tickets_path # Técnicos e Moradores vão para os chamados
    end
  end
end