require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module SistemaCondominio
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 8.1

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

  # Define o fuso horário para Brasília (que é o mesmo de Mossoró)
    config.time_zone = 'Brasilia'
    
    # Isso garante que o banco de dados também entenda o horário local
    config.active_record.default_timezone = :local

   config.active_storage.replace_on_assign_to_many = false
  end
end
