require 'colorize'
require_relative './lib/parser'

if ARGV.length != 2
  puts 'Invalid arguments.'.red
  puts "Usage: \n\s\s#{__FILE__} <url> <output_file>"
  exit
end

CATEGORY = ARGV[0]
OUTPUT_FILE = ARGV[1]

Parser.start
