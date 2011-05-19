# carga datos de un csv en un array de hashes
def load_raw_data
  result = []
  column_names = nil  
  CSV.foreach("datos_preliminares_censo_2010_argentina.csv", :col_sep =>',', :row_sep =>:auto) do |row|
    unless column_names
      column_names = []
      column_names = row
    else
      hash = {}
      row.each_with_index do |value, pos|
        hash[column_names[pos]] = value
      end
      result << hash
    end
  end
  result
end

# usa RAW_DATA
def calcular_personas_por_vivenda
  result = []
  RAW_DATA.each do |source|
    hash = {}
    hash["DEPARTAMTO"] = source["DEPARTAMTO"]
    hash["TOTAL_PERSONAS"] = source["TOTAL_MUJERES"].to_i + source["TOTAL_VARONES"].to_i
    hash["TOTAL_VIVIENDAS"] = source["TOTAL_VIVIENDAS"].to_i
    hash["PERSONAS_POR_VIVIENDA"] = hash["TOTAL_PERSONAS"].to_f / hash["TOTAL_VIVIENDAS"]
    hash["VARONES_POR_VIVIENDA"] = source["TOTAL_VARONES"].to_f / hash["TOTAL_VIVIENDAS"]
    hash["MUJERES_POR_VIVIENDA"] = source["TOTAL_MUJERES"].to_f / hash["TOTAL_VIVIENDAS"]
    result << hash
  end
  result
end