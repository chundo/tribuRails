class CreateReports < ActiveRecord::Migration[5.2]
  def change
    create_table :reports do |t|
      t.string :name
      t.string :image_a
      t.string :image_b

      t.timestamps
    end
  end
end
