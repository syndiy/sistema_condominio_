# Antes estava ApplicationRecord (que é para Models). O correto é ApplicationController
class CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @ticket = Ticket.find(params[:ticket_id])
    @comment = @ticket.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      redirect_to @ticket, notice: "Comentário enviado com sucesso!"
    else
      redirect_to @ticket, alert: "Não foi possível enviar o comentário."
    end
  end

  private

  def comment_params
    # Permitindo o conteúdo e a lista de mídias (fotos/vídeos)
    params.require(:comment).permit(:content, medias: [])
  end
end