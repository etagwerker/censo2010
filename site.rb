# encoding: utf-8

require "cuba"
require "csv"
require "haml"
require "data_mapper"
require "dm-postgres-adapter"
require "dm-migrations"
require "dm-serializer/to_json"

require "./data_init"

VERSION = "0.2"

Dir.glob(File.dirname(__FILE__) + '/app/models/*') {|file| require file}
DataMapper.finalize

DataMapper::Logger.new($stdout, :debug)
DataMapper.setup(:default, ENV['DATABASE_URL'] || 'postgres://mnwo:mnw0@localhost/censo_2010')
DataMapper.auto_upgrade!

load_raw_data

Cuba.use Rack::Session::Cookie

# Esto define una simple API para ver datos en JSON
# del Censo de Argentina 2010.
# Datos de http://bit.ly/kac3xe (by @jazzido)
Cuba.define do
  def partial(view, options = {})
    render("views/#{view}.haml", options)
  end
  
  # takes buenos_aires and it turns it into
  # BUENOS AIRES, for example
  def sanitize(param)
    result = param.sub(/_/,' ')
    result.upcase!
  end

  def layout(layout, options)
    render("views/#{layout}.haml", options)
  end

  def page(view, options = {})
    res.write layout("layout", content: partial(view, options))
  end

  on get do
    
    on "version" do |variable|
      res.write VERSION.to_json
    end
    
    on "" do
      page("home")
    end
    
    on "cabeceras" do 
      res.write Departamento.all(:fields => [:cabecera], :unique => true, :order => :cabecera.asc).map(&:cabecera).to_json
    end
        
    on "departamentos" do
      res.write Departamento.all(:fields => [:nombre], :unique => true, :order => :nombre.asc).map(&:nombre).to_json        
    end
    
    on "provincias" do 
      res.write Departamento.all(:fields => [:provincia], :unique => true, :order => :provincia.asc).map(&:provincia).to_json
    end

    on "raw_data" do
      # points todavia no lo muestra porque no se 
      # como hace datamapper para cargar las associations
      # 'eagerly', cuando lo sepa sera arreglado (@etagwerker)
      res.write Departamento.all.to_json
    end

    on "personas_por_vivienda" do
      res.write Departamento.all.to_json(:only => [:nombre, :cabecera, :provincia], :methods => [:total_personas, :personas_por_vivienda, :mujeres_por_vivienda, :varones_por_vivienda])
    end
    
    on ":provincia" do |pcia|
      on "" do
        res.write Departamento.all(:provincia => sanitize(pcia)).to_json        
      end
      
      on "departamentos" do
        res.write Departamento.all(:provincia => sanitize(pcia), :order => :nombre.asc).map(&:nombre).to_json        
      end
      
      on "cabeceras" do 
        res.write Departamento.all(:provincia => sanitize(pcia), :order => :cabecera.asc).map(&:cabecera).to_json
      end
      
      on "personas_por_vivienda" do
        res.write Departamento.all(:provincia => sanitize(pcia)).to_json(:only => [:nombre, :cabecera, :provincia], :methods => [:total_personas, :personas_por_vivienda, :mujeres_por_vivienda, :varones_por_vivienda])
      end
      
      on ":departamento" do |depto|
        
        on "" do 
          res.write Departamento.all(:nombre => sanitize(depto), :provincia => sanitize(pcia)).to_json            
        end
        
        on "personas_por_vivienda" do
          res.write Departamento.all(:nombre => sanitize(depto), :provincia => sanitize(pcia)).to_json(:only => [:nombre, :cabecera, :provincia], :methods => [:total_personas, :personas_por_vivienda, :mujeres_por_vivienda, :varones_por_vivienda])
        end
      end
          
    end
      
  end
end
