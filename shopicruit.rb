require 'net/http'
require 'json'
API_ENDPOINT = "http://shopicruit.myshopify.com/products.json?page="
current_page = 1
products = []
loop do
  puts "Endpoint hit: #{API_ENDPOINT}#{current_page}"
  uri = URI("#{API_ENDPOINT}#{current_page}")
  response = Net::HTTP.get(uri)
  json = JSON.parse(response)
  break unless json.has_key?('products') && !json['products'].empty?
  current_page += 1
  products.concat json['products']
end
watchs_and_clocks = products.select do |p|
  p['product_type'].eql?('Watch') || p['product_type'].eql?('Clock')
end

price = watchs_and_clocks.flat_map { |w| w['variants'] }.map { |w| w['price'].to_f }.reduce(:+)
puts "Total Price: $#{price.round(2)}"
