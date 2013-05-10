require "data_mapper"
require "dm-postgres-adapter"
require "dm-migrations"
require "dm-serializer/to_json"
require "csv"

Dir.glob(File.dirname(__FILE__) + '/../app/models/*') {|file| require file}

DataMapper::Logger.new($stdout, :info)

DataMapper.finalize
if ENV['DATABASE_URL']
  DataMapper.setup(:default, ENV['DATABASE_URL'])
else
  DataMapper.setup(:default, :adapter => 'postgres', :user => 'mnwo', :password => 'mnw0', :host => 'localhost', :database => 'censo', :encoding => 'UTF-8')  
end

DataMapper.auto_upgrade!
