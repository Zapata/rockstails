require 'rake'
require 'rake_performance'

ENV['APP_ENV'] ||= 'default_env'
ENV['DATABASE_URL'] ||= 'postgres://rockstails:pass@localhost/rockstails'

require 'sinatra/activerecord'
require 'sinatra/activerecord/rake'


require_relative 'db/backup_tasks'


require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList['test/*_test.rb']
  t.verbose = true
  t.options = '-v'
end
