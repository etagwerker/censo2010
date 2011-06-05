class Point
  include DataMapper::Resource
  
  property :id, Serial
  property :latitud, String
  property :longitud, String
  property :altitude, String
  
  belongs_to :departamento
  
  # knows how to initialize the object with a 
  # string like this "-60.179968,-33.34271,0.0"
  def initialize(depto, string)
    puts "Creating Point"
    self.departamento = depto
    attributes = string.split(',')
    self.longitud = attributes[0]
    self.latitud = attributes[1]
    self.altitude = attributes[2]
    puts "Created Point #{self.longitud},#{self.latitud}"
  end
end