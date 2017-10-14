class IndexController < ApplicationController
  def index

    @product_types = ProductsByType.product_types

    @product_list = Array.new
    @product_types.each do |product_types|
      prd = ProductsByType.product_list_by_product_id(product_types.product_type_id, 10)
      if(prd.length==0)
        next
      end
      products = Products.new(product_types.product_name, product_types.product_type_id, prd)
      # puts products
      @product_list.push(products)
    end
  end

  def pt
    @product_type_id = params[:id]
    @product_type = ProductsByType.product_type(@product_type_id)
    @products = ProductsByType.product_list_by_product_id(@product_type_id, 99999)
  end

end

class Products
  def initialize(name, ptid, pro)
    @name = name
    @ptid = ptid
    @pro = pro
  end
  def ptid
    @ptid
  end
  def name
    @name
  end
  def pro
    @pro
  end
end