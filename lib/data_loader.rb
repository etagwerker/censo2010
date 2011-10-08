require "data_mapper"
require "dm-postgres-adapter"
require "dm-migrations"
require "dm-serializer/to_json"
require "csv"

Dir.glob(File.dirname(__FILE__) + '/../app/models/*') {|file| require file}

DataMapper::Logger.new($stdout, :info)

DataMapper.finalize
DataMapper.setup(:default, ENV['DATABASE_URL'] || 'postgres://mnwo:mnw0@localhost/censo')
DataMapper.auto_upgrade!
