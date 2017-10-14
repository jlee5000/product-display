class ProductsByType < ActiveRecord::Base
  @filter = "
    trim(
      regexp_replace(
        regexp_replace(
          regexp_replace(p.name,';|:',' ','g'),
        concat(coalesce(b.name,'')) , '', 'g'),
      '[ ]{2,}',' ','g')
    )"

  def self.index
    ProductType.find_by_sql("
        select
          pt.product_type_id,
          pt.name as product_type,
          #{@filter} as product_name,
          p.sell_price,
          p.vendor,
          coalesce(b.name,pt.name) as brand_name
        from product_types pt
          left join products p
            on pt.product_type_id = p.product_type_id
          left join brands b
            on p.brand_id = b.brand_id
        where p.active = 't'
          and p.sell_price > 0
        order by pt.name, p.sell_price
      ")
  end


  def self.product_types
    ProductType.find_by_sql('
      select
        pt.name as product_name,
        pt.product_type_id
      from product_types pt
      order by pt.name
      ')
  end

  def self.product_type(product_type_id)
    ProductType.find_by_sql(['
      select
        pt.name as product_name,
        pt.product_type_id
      from product_types pt
      where pt.product_type_id = ?
      order by pt.name
      ',product_type_id])
  end

  def self.product_list_by_product_id(product_type_id, limit)
    ProductType.find_by_sql(["
        select
          pt.name as product_type,
          #{@filter} as product_name,
          p.sell_price,
          p.vendor,
          coalesce(b.name,pt.name) as brand_name
        from product_types pt
          left join products p
            on pt.product_type_id = p.product_type_id
          left join brands b
            on p.brand_id = b.brand_id
        where p.active = 't'
          and p.sell_price > 0
          and pt.product_type_id = ?
        order by pt.name, p.sell_price
        limit ? offset 0
      ", product_type_id, limit])
  end

  def self.product_list_by_search_term_and_product_type_id(product_type, search_term)
    ProductType.find_by_sql(["
        select
          pt.name as product_type,
          #{@filter} as product_name,
          p.sell_price,
          p.vendor,
          coalesce(b.name,pt.name) as brand_name
        from product_types pt
          left join products p
            on pt.product_type_id = p.product_type_id
          left join brands b
            on p.brand_id = b.brand_id
        where p.active = 't'
          and p.sell_price > 0
          and pt.product_type = ?
          and lower(p.name) like '%?%'
        order by pt.name, p.sell_price
      ", product_type, search_term])
  end



end