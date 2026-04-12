# Antes estava ApplicationRecord (que é para Models). O correto é ApplicationController
class CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @ticket = Ticket.find(params[:ticket_id])
    @comment = @ticket.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      # Redireciona de volta para a tela do chamado
      redirect_to ticket_path(@ticket), notice: "Mensagem enviada!"
    else
      redirect_to ticket_path(@ticket), alert: "Não foi possível enviar a mensagem."
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end
end