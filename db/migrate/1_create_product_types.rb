class CreateProductTypes < ActiveRecord::Migration[5.0]
  def change
    create_table :product_types do |t|
      t.string :product_type_id
      t.string :name #, collation: 'NOCASE'
      t.string :is_marijuana

      t.timestamps
    end
  end
end
