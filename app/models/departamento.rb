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
    Departamento.all(calculate_conditions(:provincia => pcia).merge(opts))
  end
  
  def self.departamentos_for(pcia)
    self.find_all_by_provincia(pcia, :fields => [:nombre], :unique => true, :order => :nombre.asc).map(&:nombre)
  end
  
  def self.find_all_by(opts = {})
    Departamento.all(calculate_conditions(opts))
  end
  
  def self.population_totals_for(opts = {})
    array = Departamento.aggregate(:total_mujeres.sum, :total_varones.sum, calculate_conditions(opts))
    {:total_mujeres => array[0], :total_varones => array[1]}
  end
  
  private
  
    # Calculates the conditions hash to be used. 
    # 
    # @param [Hash] :provincia => provincia, :nombre => departamento
    # @return [Hash] {:conditions => ["query1 = ? and query2 = ?", value1, value2]}
    def self.calculate_conditions(opts = {})
      conditions_array = []
      conditions_values = []
      
      if opts[:provincia]
        conditions_array << " upper(translate(provincia, 'áóéíú', 'aoeiu')) = ? "
        conditions_values << opts[:provincia]
      end

      if opts[:nombre]
        conditions_array << " upper(translate(nombre, 'áóéíú', 'aoeiu')) = ? "
        conditions_values << opts[:nombre]
      end
      
      conditions = [conditions_array.join(" and ")]
      
      {:conditions => conditions + conditions_values}
    end
end