class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :ticket
  
  # Certifique-se de que o nome aqui é o mesmo que você usou no formulário (medias)
  has_many_attached :medias 
end