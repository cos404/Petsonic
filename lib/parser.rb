require 'curb'
require 'nokogiri'
require 'colorize'
require_relative 'items_parser'

# The main module responsible for starting parsing categories and items
module Parser
  def self.start
    puts 'Parse category'.light_green
    html = Nokogiri::HTML(Curl.get(CATEGORY).body_str)
    id_category = get_category_id(html)
    items_count = get_items_count(html)

    full_category = "#{CATEGORY}?id_category=#{id_category}&n=#{items_count}"
    html = Nokogiri::HTML(Curl.get(full_category).body_str)
    items_links = get_items_links(html)

    ItemsParser.start(items_links)
  end

  private_class_method def self.get_category_id(html)
    html.xpath("//form//input[@name='id_category']/@value")
  end

  private_class_method def self.get_items_count(html)
    html.xpath("//form//input[@name='n']/@value")
  end

  private_class_method def self.get_items_links(html)
    html.xpath("//a[@class='product_img_link product-list-category-img']/@href")
  end
end
