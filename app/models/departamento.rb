class Departamento
  include DataMapper::Resource
  
  property :id, Serial
  property :nombre, String, :index => true
  property :provincia, String, :index => true
  property :total_mujeres, Integer
  property :total_varones, Integer
  property :edad, Integer
  
  def total_personas
   self.total_mujeres + self.total_varones 
  end
end