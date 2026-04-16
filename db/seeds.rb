puts "Limpando banco de dados com força bruta (PostgreSQL)..."

ActiveRecord::Base.connection.disable_referential_integrity do
  tables = [
    'responsabilidades', 'comments', 'user_units', 'tickets', 
    'ticket_types', 'statuses', 'units', 'blocks', 'users',
    'active_storage_attachments', 'active_storage_blobs', 'active_storage_variant_records'
  ]
  
  tables.each do |table|
    if ActiveRecord::Base.connection.table_exists? table
      ActiveRecord::Base.connection.execute("TRUNCATE TABLE #{table} RESTART IDENTITY CASCADE")
    end
  end
end

puts "✅ Banco limpo! Começando a semear..."

# --- STATUS ---
puts "Criando Status..."
['Aberto', 'Em Atendimento', 'Concluído', 'Cancelado'].each { |nome| Status.create!(name: nome) }

# --- CATEGORIAS COM SLA ---
puts "Criando Categorias..."
categorias_data = [
  { title: 'Manutenção', sla: 24 },
  { title: 'Elétrica', sla: 12 },
  { title: 'Limpeza', sla: 4 },
  { title: 'Segurança', sla: 1 },
  { title: 'Financeiro', sla: 48 },

]

categorias_data.each do |cat|
  TicketType.create!(title: cat[:title], sla_hours: cat[:sla])
end

# --- ESTRUTURA FÍSICA (AUTOMÁTICA) ---
puts "Criando Blocos (as unidades nascem sozinhas)..."
Block.create!(identification: "Bloco A", floors_count: 2, apartments_per_floor: 2)
Block.create!(identification: "Bloco B", floors_count: 2, apartments_per_floor: 2)

# --- USUÁRIOS ---
puts "Criando Equipe de Teste..."

# 1. Admin
User.create!(name: "ADM Geral", email: "admin@email.com", password: "senha123", role: :admin)

# 2. Morador
morador = User.create!(name: "Morador", email: "morador@email.com", password: "senha123", role: :morador)

# 3. Time de Colaboradores (Um para cada cargo)
colaboradores = [
  { name: "Marcio Manutenção", email: "manutencao@email.com", cat: "Manutenção" },
  { name: "Edison Elétrica", email: "eletrica@email.com", cat: "Elétrica" },
  { name: "Lia Limpeza", email: "limpeza@email.com", cat: "Limpeza" },
  { name: "Saulo Segurança", email: "seguranca@email.com", cat: "Segurança" },
  { name: "Fabio Financeiro", email: "financeiro@email.com", cat: "Financeiro" }
]

colaboradores.each do |colab|
  u = User.create!(
    name: colab[:name],
    email: colab[:email],
    password: "senha123",
    role: :colaborador
  )
  # Vincula o cara à categoria dele
  tipo = TicketType.find_by(title: colab[:cat])
  Responsabilidade.create!(user: u, ticket_type: tipo)
end

# --- VÍNCULO MORADOR ---
puts "Vinculando Morador..."
sleep 1 # Tempo para o banco processar as unidades automáticas
UserUnit.create!(user: morador, unit: Unit.find_by(number: "A101"))

puts ""
puts "=============================================="
puts "       SISTEMA PRONTO PARA TESTES!            "
puts "=============================================="
puts "  SENHA PADRÃO PARA TODOS: senha123"
puts "----------------------------------------------"
puts "  - MORADOR: morador@email.com"
puts "  - ADM: admin@email.com"
puts "  - SEGURANÇA: seguranca@email.com"
puts "  - MANUTENÇÃO: manutencao@email.com"
puts "  - ELÉTRICA: eletrica@email.com"
puts "  - LIMPEZA: limpeza@email.com"
puts "  - FINANCEIRO: financeiro@email.com"
puts "  - MORADOR: morador@email.com"
puts "=============================================="