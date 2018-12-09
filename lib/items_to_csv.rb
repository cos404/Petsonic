require 'csv'
require 'colorize'

# This is module create csv file and writes to it information about the items
module ItemsToCSV
  def self.write(items)
    Dir.mkdir('csv') unless File.exist?('csv')
    CSV.open("csv/#{OUTPUT_FILE}.csv", 'wb') do |csv|
      csv << %w[Name Price Image]
      items.each do |item|
        csv << item
      end
    end
    puts 'Complete!'.green
  end
end
