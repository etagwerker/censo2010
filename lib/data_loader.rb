require "data_mapper"
require "dm-postgres-adapter"
require "dm-migrations"
require "dm-serializer/to_json"
require "csv"

Dir.glob(File.dirname(__FILE__) + '/../app/models/*') {|file| require file}

DataMapper::Logger.new($stdout, :info)

DataMapper.finalize
DataMapper.setup(:default, ENV['DATABASE_URL'] || 'postgres://mnwo:mnw0@localhost/censo_2010')
DataMapper.auto_upgrade!

# loads data from the CSV
# it takes a hash as a parameter
# supported options :one, :all
# :one => true, loads to the DB only one unloaded CSV record
# :all => true, loads to the DB all of the unloaded CSV records
def load_data(opts = {})
  # defaults
  one = opts[:one] || true
  all = opts[:all] || false

  puts "Loading raw data"
  
  result = []
  column_names = nil
  pos = 0
  saved = 0
  CSV.foreach("datos_preliminares_censo_2010_argentina.csv", :col_sep =>',', :row_sep =>:auto) do |row|
    pos += 1
    unless column_names
      column_names = []
      column_names = row
    else
      hash = {}
      row.each_with_index do |value, pos|
        hash[column_names[pos]] = value
      end
      result << hash
      unless Departamento.first(:conditions => {:nombre => hash["DEPARTAMENTO"], :provincia => hash["PROVINCIA"]})
        Departamento.new(hash).save  
        saved += 1
      end
      if saved > 0 && one 
        break
      end
    end
  end
  puts "Loaded raw data"  
end
