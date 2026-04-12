json.extract! ticket, :id, :title, :description, :user_id, :unit_id, :ticket_type_id, :status_id, :finished_at, :created_at, :updated_at
json.url ticket_url(ticket, format: :json)
