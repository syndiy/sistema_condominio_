class Comment < ApplicationRecord
  belongs_to :ticket
  belongs_to :user
  has_many_attached :medias
end