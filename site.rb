require "cuba"
require "csv"
require "json"
require "haml"
require "./data_init"

RAW_DATA = load_raw_data
PERSONAS_POR_VIVENDA = calcular_personas_por_vivenda

Cuba.use Rack::Session::Cookie

# Esto define una simple API para ver datos en JSON
# del Censo de Argentina 2010.
# Datos de http://bit.ly/kac3xe (by @jazzido)
Cuba.define do
  def partial(view, options = {})
    render("views/#{view}.haml", options)
  end

  def layout(layout, options)
    render("views/#{layout}.haml", options)
  end

  def page(view, options = {})
    layout("layout", content: partial(view, options))
  end

  on get do
    on "" do
      res.write page("home")
    end

    on "raw_data" do
      res.write RAW_DATA.to_json
    end

    on "personas_por_vivienda" do
      res.write PERSONAS_POR_VIVENDA.to_json
    end
  end
end
