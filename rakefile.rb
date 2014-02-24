require 'rake'
require 'rake_performance'
require 'rake/testtask'
require 'sinatra'
require 'sinatra/activerecord/rake'
require_relative 'db/database'
require_relative 'db/backup_tasks'

Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList['test/*_test.rb']
  t.verbose = true
  t.options = '-v'
end