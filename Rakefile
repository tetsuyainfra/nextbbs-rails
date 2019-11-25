begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

require 'rdoc/task'

RDoc::Task.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'Nextbbs'
  rdoc.options << '--line-numbers'
  rdoc.rdoc_files.include('README.md')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

APP_RAKEFILE = File.expand_path("test/dummy/Rakefile", __dir__)
load 'rails/tasks/engine.rake'

load 'rails/tasks/statistics.rake'

require 'bundler/gem_tasks'

require 'rake/testtask'

Rake::TestTask.new(:test) do |t|
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = false
end

task default: :test

# desc 'Before task'
# task :before do
#   puts 'Before'
#   puts ENV['FIXTURES_DIR']
# end

# Rake::Task['db:fixtures:load'].enhance([:before]) do
#   # Rake::Task[:after].invoke
# end
# include ActiveRecord::Tasks
# DatabaseTasks.fixtures_path = "#{Rails.root}"