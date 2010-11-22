if ENV['MONGOHQ_URL']
	uri = URI.parse(ENV['MONGOHQ_URL'])
	MongoMapper.connection = Mongo::Connection.from_uri(uri)
	MongoMapper.database = MongoMapper.connection.db(uri.path.gsub(/^\//, ''))
else
	MongoMapper.connection = Mongo::Connection.new('localhost', 27017)
	MongoMapper.database = "rockstails-#{Rails.env}"
end

if defined?(PhusionPassenger)
   PhusionPassenger.on_event(:starting_worker_process) do |forked|
	 MongoMapper.connection.connect_to_master if forked
   end
end
