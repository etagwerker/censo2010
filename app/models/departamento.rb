class Departamento
  include DataMapper::Resource
  
  property :id, Serial
  property :nombre, String, :index => true
  property :cabecera, String, :index => true
  property :provincia, String, :index => true
  property :total_mujeres, Integer
  property :total_varones, Integer
  property :total_viviendas, Integer
  property :superficie, String
  property :perimetro, String
  
  has n, :points
  
  def initialize(hash)
    puts "Creating Departamento"
    self.nombre = hash['DEPARTAMENTO']
    self.cabecera = hash['CABECERA']
    self.provincia = hash['PROVINCIA']    
    self.total_mujeres = hash['TOTAL_MUJERES']
    self.total_varones = hash['TOTAL_VARONES']
    self.total_viviendas = hash['TOTAL_VIVIENDAS']        
    self.superficie = hash['SUP__HAS_']
    self.perimetro = hash['PERIMETRO']
    
    points = extract_points_array(hash)
    
    self.points = points.collect { |point| Point.new(self, point) }
    puts "Created Departamento #{self.nombre}"    
  end
  
  # returns something like this
  # ["-60.179968,-33.34271,0.0", "-60.176956,-33.344382,0.0", 
  # "-60.173887,-33.345992,0.0", "-60.17137,-33.347318,0.0"]
  def extract_points_array(hash)
    kml = hash['geometry']
    kml =~ /<coordinates>(.*)<\/coordinates>/
    $1.split(' ')
  end
  
  def personas_por_vivienda
    (self.total_personas).to_f / self.total_viviendas
  end
  
  def varones_por_vivienda
    self.total_varones.to_f / self.total_viviendas
  end
  
  def mujeres_por_vivienda
    self.total_mujeres.to_f / self.total_viviendas
  end
  
  def total_personas
   self.total_mujeres + self.total_varones 
  end
end