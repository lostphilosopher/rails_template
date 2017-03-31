# Rails Template
# See: http://guides.rubyonrails.org/rails_application_templates.html

def console_puts(string)
  puts "-" * (string.length + 4)
  puts '| ' + string + ' |'
  puts "-" * (string.length + 4)
end

console_puts('Building your Rails app from template.rb file.')

console_puts('Adding Gems from template.rb to your Gemfile.')
gem 'haml-rails', '~> 0.9.0'
gem 'bootstrap-sass', '~> 3.3.6'

gem_group :development, :test do
	gem 'rspec-rails', '~> 3.5.2'
  gem 'pry-rails', '~> 0.3.6'
end

console_puts('Running bundle install.')
run "bundle install"

def source_paths
  [File.expand_path(File.dirname(__FILE__))]
end

after_bundle do
  console_puts('Installing RSpec.')
  generate "rspec:install"

  console_puts('Converting view/layouts/application.html.erb HAML.')
  generate "haml:application_layout convert"
	run "rm app/views/layouts/application.html.erb"

  console_puts('Converting assets for Bootstrap.')
	run "pwd"
  run "rm app/assets/stylesheets/application.css"
  run "cp ../application.scss app/assets/stylesheets/application.scss"
  run "cp ../application.js app/assets/javascript/application.js"

  console_puts('Creating the database.')
  rails_command "db:create"

  console_puts('Setting up Git.')
	git :init
  git add: "."
  git commit: %Q{ -m 'Initial commit' }

  console_puts('Build complete, happy Rails-ing!')
end
