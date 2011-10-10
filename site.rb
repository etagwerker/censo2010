# encoding: utf-8

require "cuba"
require "haml"

require "./lib/data_loader.rb"

VERSION = "2.0"

Cuba.use Rack::Static, :urls => ['/js', '/public']
Cuba.use Rack::Session::Cookie

# Esto define una simple API para ver datos en JSON
# del Censo de Argentina 2010.
# Datos de http://bit.ly/kac3xe (by @jazzido)
Cuba.define do
  def partial(view, options = {})
    render("app/views/#{view}.haml", options)
  end
  
  # takes buenos_aires and it turns it into
  # BUENOS AIRES, for example
  def sanitize(param)
    result = param.sub(/_/,' ')
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
  
  on post do 
    
    # this method is just a workaround for the
    # heroku deployment and loading the data
    on "load_data" do |variable|
      @initial = Departamento.count
      load_data
      @end = Departamento.count
      page("load_data")
    end
    
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
  
    on ":provincia" do |pcia|
      on "" do
        res.write Departamento.all(:provincia => sanitize(pcia)).to_json        
      end
      
      on "departamentos" do
        res.write Departamento.all(:provincia => sanitize(pcia), :order => :nombre.asc).map(&:nombre).to_json        
      end
      
      on ":departamento" do |depto|
        
        on "" do 
          res.write Departamento.all(:nombre => sanitize(depto), :provincia => sanitize(pcia)).to_json            
        end
      end
    end
  end
end