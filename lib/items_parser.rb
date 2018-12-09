require 'curb'
require 'nokogiri'
require 'progress_bar'
require 'colorize'
require_relative 'items_to_csv'

# This is module parse items
module ItemsParser
  def self.start(links)
    items = []
    items_bar = ProgressBar.new(links.length, :bar, :rate, :eta)

    puts 'Parse items'.light_green
    links.each do |item_link|
      page = Nokogiri::HTML(Curl.get(item_link).body_str)
      title = get_title(page)
      image = get_image(page)
      get_info(page).each do |item|
        price = get_price(item)
        weight = get_weight(item)
        items << ["#{title} - #{weight}", price, image]
      end
      items_bar.increment!
    end

    ItemsToCSV.write(items)
  end

  private_class_method def self.get_title(page)
    page
      .xpath("//h1[@class='product_main_name']")
      .text
      .strip
  end

  private_class_method def self.get_image(page)
    page
      .xpath("//img[@id='bigpic']/@src")
      .text
      .strip
  end

  private_class_method def self.get_info(page)
    page
      .xpath("//ul[@class='attribute_radio_list']/li")
  end

  private_class_method def self.get_weight(info)
    info
      .xpath("child::label/span[@class='radio_label']")
      .text
      .strip
  end

  private_class_method def self.get_price(info)
    info
      .xpath("child::label/span[@class='price_comb']")
      .text
      .strip
      .sub(%r{€\/u}, '')
  end
end
