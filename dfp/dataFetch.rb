require "net/http"
require "uri"
require 'json'
require 'fileutils'

class FetchData

  @@g_uri = ''
  @@limit = 1000
  @@token = ''
  @@basic = ''
  @@sleepBetween = 2
  def strains
    data = get("#{@@g_uri}/strains")
    write('strains', data)
  end

  def companies
    data = get("#{@@g_uri}/companies")
    write('companies', data)
  end

  def product_types
    data = get("#{@@g_uri}/product_types")
    write('product-types', data)
  end

  def products
    # limit to fetch values.
    fetch('products', '&active=true&by_active=true')
  end

  def brands
    # limit to fetch values.
    fetch('brands' , false)
  end

  # gets - gets api endpoint data
  # @param [String] uri
  # @return [Object] response data.
  def get( uri )
    url = URI(uri)
    req = Net::HTTP::Get.new(url.to_s)
    req.add_field("Authorization", @@token)
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = (url.scheme == "https")
    response = http.request(req)
    response.body
  end

  # fetch - gets pages of data.
  # @param [String] locator - what the file or data object is called. USES @@limit
  def fetch( locator, custom_query_string )

    uri = "#{@@g_uri}/#{locator}?limit=1";
    uri = uri + custom_query_string if custom_query_string

    meta = JSON.parse(get(uri))
    total_records = meta['meta']['total']

    # gets information
    loops = total_records/1000

    # fetch each page of data.
    until loops < 0
      offset = loops * @@limit
      uri = "#{@@g_uri}/#{locator}?limit=#{@@limit}&offset=#{offset}"
      uri = uri + custom_query_string if custom_query_string
      data = get(uri)
      write("#{locator}" + loops.to_s, data)
      #take a nap
      sleep(@@sleepBetween)

      # reduce loops
      loops = loops-1
    end
  end

  # write - writes to file system does a check to see if the data is in json format.
  #         if it is not, it will write out json {"nodata"}
  # @param [String] locator - what the file or data object is called.
  # @param [Object] data - raw data
  def write ( locator, data )
    fn = "raw/#{locator}.json"
    if valid_json? data.to_json
      File.open(fn, 'w') { |f| f.write(data) }
    else
      File.open(fn, 'w') { |f| f.write('{"nodata"}') }
    end
  end

  # valid_json? - validates if the data is json.
  # @param [Object] json
  # @return [Boolean]
  def valid_json?( json )
    JSON.parse(json)
    true
  rescue JSON::ParserError => e
    false
  end
end

# pulls data down
f = FetchData.new
f.brands
sleep(2)
f.companies
sleep(2)
f.product_types
sleep(2)
f.products
sleep(2)
f.strains
