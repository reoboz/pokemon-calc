class CreatePokemons < ActiveRecord::Migration[6.0]
  def change
    create_table :pokemons do |t|
      t.string :name
      t.integer :type1
      t.integer :type2
      t.bigint :evolved_from
      t.bigint :evolve_to
      t.integer :h
      t.integer :a
      t.integer :b
      t.integer :c
      t.integer :d
      t.integer :s

      t.timestamps
    end
  end
end
