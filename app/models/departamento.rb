# encoding: utf-8

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
  
  def self.find_all_by_provincia(pcia, opts = {})
    Departamento.all({:conditions => ["upper(translate(provincia, 'áóéíú', 'aoeiu')) = ?", pcia]}.merge(opts))
  end
  
  def self.departamentos_for(pcia)
    self.find_all_by_provincia(pcia, :fields => [:nombre], :unique => true, :order => :nombre.asc).map(&:nombre)
  end
end