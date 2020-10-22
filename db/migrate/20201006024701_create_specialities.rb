class CreateSpecialities < ActiveRecord::Migration[6.0]
  def change
    create_table :specialities do |t|
      t.string :name
      t.text :description1
      t.text :description2
      t.text :description3

      t.timestamps
    end
  end
end
