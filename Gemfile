source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# Declare your gem's dependencies in nextbbs.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec

# Declare any dependencies that are still in development here instead of in
# your gemspec. These might include edge Rails or gems from your path or
# Git. Remember to move these dependencies to your gemspec before releasing
# your gem to rubygems.org.

# To use a debugger
# gem 'byebug', group: [:development, :test]

gem "rails", "~> 6.0.0"
gem "jquery-rails"

group :development, :test do
  gem "sqlite3"
  gem "pg"
end

group :development, :test do
  gem "devise", "~> 4.7"
  gem "devise-i18n"
end

group :development, :test do
  gem "pundit"
end

group :development, :test do
  gem 'draper'
  gem "html2slim", require: false
end

group :development, :test do
  gem 'pry' # Easily debug from your console with `binding.pry`
  gem 'pry-byebug', platform: :mri # Step-by-step debugging

  gem "byebug"

  gem "faker"
  gem "annotate"
end

group :development do
  gem "web-console"
  gem "better_errors"
  gem "binding_of_caller"
end

# 環境が整うまでdisable
#group :test do
#  # Adds support for Capybara system testing and selenium driver
#  gem 'capybara', '>= 2.15'
#  gem 'selenium-webdriver'
#  # Easy installation and use of web drivers to run system tests with browsers
#  gem 'webdrivers'
#end