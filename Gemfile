
source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

ruby '2.7.4'

gem 'nokogiri', '~> 1.10'

gem 'loofah', '~> 2.21.1'

gem 'rails', '~> 5.2.0'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 3.7'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'

gem 'coffee-rails', '~> 4.2'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.5'

gem 'prawn', '~> 2.1'
gem 'prawn-table', '~> 0.2.2'
gem 'baht'

gem 'pdfkit' 
gem 'wicked_pdf'
gem 'vanilla_nested'
gem 'carrierwave'

gem 'axlsx'
gem 'caxlsx_rails'

gem 'matrix'
gem 'aws-sdk-s3', require: false
gem 'rack-timeout'

gem 'figaro'
gem 'unf'
gem 'dotenv'

gem 'dotenv-rails'
gem 'nested_form_fields'
gem 'cocoon'


gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'rails_sortable'
gem 'jquery-qtip2-wrapper-rails'

gem 'mini_magick'
gem 'paper_trail'


group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]


