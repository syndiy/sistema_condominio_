class Comment < ApplicationRecord
  belongs_to :ticket
  belongs_to :user
  
  # Verifique se o nome aqui é IGUAL ao que está no controller e na view
  has_many_attached :medias
end