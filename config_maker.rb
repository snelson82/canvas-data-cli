require 'fileutils'
require 'io/console'

# Gets domain for config file and PATH updates
puts 'Enter domain for config generation:'
domain = gets.chomp!.downcase

if ENV["#{domain.upcase}_API_KEY"].nil? && ENV["#{domain.upcase}_API_SECRET"].nil?
  puts "Enter the Canvas Data KEY for #{domain}"
  cdata_key = STDIN.noecho(&:gets).chomp!

  puts "Enter the Canvas Data SECRET for #{domain}"
  cdata_secret = STDIN.noecho(&:gets).chomp!

  File.open('../../cdata', 'a+') do |file|
    file << "\n\n# #{domain}.instructure.com\n"
    file << "export #{domain.upcase}_API_KEY=\"#{cdata_key}\"\n"
    file << "export #{domain.upcase}_API_SECRET=\"#{cdata_secret}\"\n"
  end

  # Creates config file
  File.open("#{domain}_config.js", 'w+') do |file|
    file << "module.exports = {\n"
    file << "\s\ssaveLocation: \"./#{domain}_dataFiles\",\n"
    file << "\s\sunpackLocation: \"./#{domain}_unpackedFiles\",\n"
    file << "\s\sapiUrl: \"https://api.inshosteddata.com/api\",\n"
    file << "\s\skey: process.env.#{domain.upcase}_API_KEY,\n"
    file << "\s\ssecret: process.env.#{domain.upcase}_API_SECRET\n"
    file << "};\n"
  end

  system('source ~/cdata')
  Dir.mkdir("./#{domain}_dataFiles") unless Dir.exist?("./#{domain}_dataFiles")
  Dir.mkdir("./#{domain}_unpackedFiles") unless Dir.exist?("./#{domain}_unpackedFiles")
end

puts 'Done for now'
