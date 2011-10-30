# encoding: utf-8

require "cuba"
require "haml"
require "rack/jsonp"

require "./lib/data_loader.rb"

VERSION = "2.0"

Cuba.use Rack::Static, :urls => ['/js', '/public']
Cuba.use Rack::JSONP 
Cuba.use Rack::Session::Cookie

# Una simple API para ver datos en JSON
# del Censo de Argentina 2010.
# 
# Datos de https://github.com/etagwerker/c2010-scrapper
Cuba.define do
  def partial(view, options = {})
    render("app/views/#{view}.haml", options)
  end
  
  # takes buenos_aires and it turns it into
  # BUENOS AIRES, for example
  def sanitize(param)
    param = CGI::unescape(param)
    param = Iconv.new('ASCII//IGNORE//TRANSLIT', 'UTF-8').iconv(param)
    param = param.gsub(/[^\-x00-\x7F]/n, '').to_s
    result = param.gsub(/_/,' ')
    result.upcase!
  end
    
  def as_record(value)
    { :id => parameterize(value), :nombre => value }
  end

  def parameterize(id)
    id.to_s.downcase.gsub(" ", "_")
  end

  def layout(layout, options)
    render("app/views/#{layout}.haml", options)
  end

  def page(view, options = {})
    res['Content-Type'] = 'text/html'
    res.write layout("layout", content: partial(view, options))
  end

  on get do
    res['Content-Type'] = 'application/json'
    
    on "" do
      page("home")
    end
        
    on "departamentos" do
      res.write Departamento.all(:fields => [:nombre], :unique => true, :order => :nombre.asc).map { |d| 
        as_record(d.nombre) }.to_json
    end
    
    on "provincias" do 
      res.write Departamento.all(:fields => [:provincia], :unique => true, :order => :provincia.asc).map { |d| 
        as_record(d.provincia) }.to_json
    end
    
    on "version" do |variable|
      res.write VERSION.to_json
    end

    on "raw_data" do
      res.write Departamento.all.to_json
    end
    
    on "poblacion" do
      on ":provincia" do |pcia|
        on "" do
          res.write Departamento.find_all_by_provincia(sanitize(pcia)).to_json        
        end
        
        on "totales" do
          res.write Departamento.population_totals_for(:provincia => sanitize(pcia)).to_json            
        end

        on ":departamento" do |depto|

          on "" do 
            res.write Departamento.find_all_by(:nombre => sanitize(depto), :provincia => sanitize(pcia)).to_json            
          end
          
          on "totales" do
            res.write Departamento.population_totals_for(:nombre => sanitize(depto), :provincia => sanitize(pcia)).to_json            
          end
        end
      end      
    end
    
    on ":provincia" do |pcia|

      on "departamentos" do
        res.write Departamento.departamentos_for(sanitize(pcia)).map { |d| 
          as_record(d)}.to_json
      end
      
    end

  end
end