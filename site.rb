require "cuba"
require "csv"
require "json"
require "./data_init"

RAW_DATA = load_raw_data
PERSONAS_POR_VIVENDA = calcular_personas_por_vivenda

Cuba.use Rack::Session::Cookie

Cuba.define do
  on get do
    on "hello" do
      res.write "Hola! Esta es una API. "
    end
    
    on "raw_data" do 
      res.write RAW_DATA.to_json
    end
    
    on "personas_por_vivienda" do
      res.write PERSONAS_POR_VIVENDA.to_json
    end

    on true do
      res.redirect "/hello"
    end
  end
end

# cat hello_world_test.rb
require "cuba/test"

scope do
  test "Homepage" do
    visit "/"
  end
end