class CreateProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :products do |t|
      t.string :product_id
      t.string :name #, collation: 'NOCASE'
      t.integer :sell_price
      t.string :vendor #, collation: 'NOCASE'
      t.string :active
      t.string :product_type_id
      t.string :brand_id
      t.string :category_id

      t.timestamps
    end
  end
end
