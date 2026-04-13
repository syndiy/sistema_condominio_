class Block < ApplicationRecord
  has_many :units, dependent: :destroy
  
  after_create :generate_units
  after_update :generate_units

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
    # 1. Lógica do alfabeto
    alfabeto = ("A".."Z").to_a
    index = Block.order(:created_at).pluck(:id).index(self.id) || 0
    letra_unidade = alfabeto[index % 26]

    # 2. CRIAR OU MANTER UNIDADES
    (1..self.floors_count).each do |andar|
      (1..self.apartments_per_floor).each do |apto|
        numero_unidade = "#{letra_unidade}#{andar}#{apto.to_s.rjust(2, '0')}"
        
        self.units.find_or_create_by!(number: numero_unidade) do |u|
          u.floor = "#{andar}º andar"
        end
      end
    end

    # 3. LIMPAR UNIDADES EXCEDENTES (O fim do B501 fantasma)
    self.units.each do |unit|
      numeros = unit.number.scan(/\d+/).join
      next if numeros.empty?

      # Extrai andar e apto dos números da etiqueta
      andar_da_unidade = numeros.length == 3 ? numeros[0].to_i : numeros[0..1].to_i
      apto_da_unidade = numeros.last(2).to_i

      if andar_da_unidade > self.floors_count || apto_da_unidade > self.apartments_per_floor
        # Segurança: Não deleta se houver vínculos
        if (unit.respond_to?(:users) && unit.users.any?) || (unit.respond_to?(:tickets) && unit.tickets.any?)
          Rails.logger.info "Unidade #{unit.number} preservada por conter vínculos."
        else
          unit.destroy
        end
      end
    end
  end
end