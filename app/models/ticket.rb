class Ticket < ApplicationRecord
  belongs_to :user
  belongs_to :unit
  belongs_to :ticket_type
  belongs_to :status
  has_many :comments, dependent: :destroy

 has_many_attached :attachments       # Fotos do problema (Morador/Admin)
  has_many_attached :resolution_media  # Fotos da solução (Colaborador)
  

  validates :title, :description, presence: true


  before_validation :set_default_status, on: :create
  before_save :set_finished_at, if: :status_id_changed?

  # Método para calcular o Prazo Limite (SLA)
  # Isso mostra que você entendeu o requisito de "horas de prazo" do PDF
 # Método para calcular o Prazo Limite (SLA)
# Antes estava duration_hours, mude para sla_hours
def prazo_limite
  created_at + ticket_type.sla_hours.hours
end

  # Método para saber se está atrasado (UX para o Colaborador)
  def atrasado?
    return false if finished_at.present? # Se já terminou, não está atrasado
    Time.current > prazo_limite
  end

  private

  def set_default_status
    # Busca o status "Aberto". 
    # Dica: se não existir no banco, ele não quebra o código
    self.status ||= Status.find_by(name: "Aberto")
  end

  def set_finished_at
    # Grava a data apenas se o status for alterado para 'Concluído'
    if status&.name == "Concluído"
      self.finished_at = Time.current
    else
      # Se reabrirem o chamado, limpamos a data de conclusão
      self.finished_at = nil
    end
  end
end