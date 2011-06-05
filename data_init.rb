# carga datos de un csv en un array de hashes
# y en la base de datos
def load_raw_data
  puts "Loading raw data"
  
  result = []
  column_names = nil
  pos = 0
  CSV.foreach("datos_preliminares_censo_2010_argentina.csv", :col_sep =>',', :row_sep =>:auto) do |row|
    pos += 1
    unless column_names
      column_names = []
      column_names = row
    else
      puts "Loading departamento ##{pos}"
      hash = {}
      row.each_with_index do |value, pos|
        hash[column_names[pos]] = value
      end
      result << hash
      unless Departamento.first(:conditions => {:nombre => hash["DEPARTAMENTO"], :provincia => hash["PROVINCIA"]})
        Departamento.new(hash).save  
      end
      puts "Loaded departamento"
    end
  end
  puts "Loaded raw data"
end

