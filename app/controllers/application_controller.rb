class ApplicationController < ActionController::Base
  # Força o login em todas as telas do sistema
  before_action :authenticate_user!
end