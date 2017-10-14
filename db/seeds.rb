# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


def run_products(data)
  data.each do |a|
    Product.create!({
        product_id: a['id'],
        name: a['name'],
        sell_price: a['sell_price'],
        vendor: a['vendor'],
        active: a['active'],
        product_type_id: a['product_type_id'],
        brand_id: a['brand_id'],
        category_id: a['category_id']})
  end
end

def run_brands(data)
  data.each do |a|
    Brand.create!({
        brand_id: a['id'],
        name: a['name'],
    })
  end
end

def run_product_types(data)
  data.each do |a|
    ProductType.create!({
        product_type_id: a['id'],
        name: a['name'],
        is_marijuana: a['is_marijuana']
    })
  end
end

Dir.foreach('dfp/raw') do |item|
  next if item == '.' or item == '..'
  if(item.include?('products'))
    json = ActiveSupport::JSON.decode(File.read("dfp/raw/#{item}"))
    run_products(json['products'])

  elsif(item.include?('brands'))
    json = ActiveSupport::JSON.decode(File.read("dfp/raw/#{item}"))
    run_brands(json['brands'])

  elsif(item.include?('product-type'))
    json = ActiveSupport::JSON.decode(File.read("dfp/raw/#{item}"))
    run_product_types(json['product_types'])

  else
    next;
  end
end