$:.unshift(File.dirname(__FILE__) + '/../lib/db_wrapper')

Gem.find_files('db_wrapper/**/*.rb').each { |file| require file }
