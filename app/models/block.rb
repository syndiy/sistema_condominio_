class Block < ApplicationRecord
  has_many :units, dependent: :destroy
  
  # Gatilhos para geração automática conforme o desafio
  after_create :generate_units
  after_update :generate_units

  # --- AS TRAVAS DE SEGURANÇA ---
  validates :identification, presence: true, uniqueness: true
  
  validates :floors_count, presence: true, numericality: { 
    only_integer: true, 
    greater_than: 0, 
    less_than_or_equal_to: 99 
  }

  validates :apartments_per_floor, presence: true, numericality: { 
    only_integer: true, 
    greater_than: 0, 
    less_than_or_equal_to: 99 
  }

  private

  def generate_units
    # 1. Lógica do alfabeto para manter o padrão A101, B101, etc.
    alfabeto = ("A".."Z").to_a
    index = Block.order(:created_at).pluck(:id).index(self.id) || 0
    letra_unidade = alfabeto[index % 26]

    # 2. CRIAR OU MANTER UNIDADES (EXPANSÃO)
    (1..self.floors_count).each do |andar|
      (1..self.apartments_per_floor).each do |apto|
        numero_unidade = "#{letra_unidade}#{andar}#{apto.to_s.rjust(2, '0')}"
        
        # find_or_create_by evita duplicar unidades existentes
        self.units.find_or_create_by!(number: numero_unidade) do |u|
          u.floor = "#{andar}º andar"
        end
      end
    end

    # 3. LIMPAR UNIDADES EXCEDENTES (REDUÇÃO SEGURA)
    self.units.each do |unit|
      match = unit.number.match(/#{letra_unidade}(\d+)(\d{2})/)
      next unless match

      andar_da_unidade = match[1].to_i
      apto_da_unidade = match[2].to_i

      if andar_da_unidade > self.floors_count || apto_da_unidade > self.apartments_per_floor
        # Verifica se há moradores ou chamados antes de deletar
        if unit.users.any? || (unit.respond_to?(:tickets) && unit.tickets.any?)
          Rails.logger.info "Unidade #{unit.number} preservada por conter vínculos."
        else
          unit.destroy
        end
      end
    end
  end
end