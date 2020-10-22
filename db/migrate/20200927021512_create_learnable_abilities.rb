class CreateLearnableAbilities < ActiveRecord::Migration[6.0]
  def change
    create_table :learnable_abilities do |t|
      t.bigint :ability_id
      t.bigint :pokemon_id

      t.timestamps
    end
  end
end
