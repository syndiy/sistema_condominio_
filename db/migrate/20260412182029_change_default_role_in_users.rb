class ChangeDefaultRoleInUsers < ActiveRecord::Migration[7.1]
  def change
    # Garante que, se ninguém disser nada, o usuário nasce como morador (0)
    change_column_default :users, :role, from: nil, to: 0
  end
end