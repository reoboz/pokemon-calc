class CreateLearnableSpecialities < ActiveRecord::Migration[6.0]
  def change
    create_table :learnable_specialities do |t|
      t.bigint :speciality_id
      t.bigint :pokemon_id

      t.timestamps
    end
  end
end
