class CreateBrands < ActiveRecord::Migration[5.0]
  def change
    create_table :brands do |t|
      t.string :brand_id
      t.string :name #, collation: 'NOCASE'

      t.timestamps
    end
  end
end
