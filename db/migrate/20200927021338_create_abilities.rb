class CreateAbilities < ActiveRecord::Migration[6.0]
  def change
    create_table :abilities do |t|
      t.integer :type
      t.integer :damage_type
      t.integer :amount
      t.integer :accuracy
      t.integer :min_hits
      t.integer :max_hits

      t.timestamps
    end
  end
end
