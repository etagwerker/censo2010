require "cuba"
require "csv"
require "json"
require "tilt"
require "haml"
require "./data_init"

RAW_DATA = load_raw_data
PERSONAS_POR_VIVENDA = calcular_personas_por_vivenda

Cuba.use Rack::Session::Cookie

# Esto define una simple API para ver datos en JSON
# del Censo de Argentina 2010. 
# Datos de http://bit.ly/kac3xe (by @jazzido)
Cuba.define do
  on get do
    on "hello" do
      template = Tilt::HamlTemplate.new('templates/hello.html.haml')
      res.write template.render
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