json.extract! report, :id, :name, :image_a, :image_b, :created_at, :updated_at
json.url report_url(report, format: :json)
