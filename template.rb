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
  gem "factory_girl", '4.8.1'
end

console_puts('Option: Devise')
if yes?("Add Devise?")
  gem 'devise', '~> 4.4.1'
  run "bundle install"
  run "rails generate devise:install"
  run "rails generate devise User"
  inject_into_file 'config/environments/development.rb', after: "config.action_mailer.perform_caching = false" do
    "\n\n  config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }\n\n"
  end
end

console_puts('Running bundle install.')
run "bundle install"

inject_into_file 'config/application.rb', before: "  end" do
  "\n    config.generators.assets = false \n\n    config.generators.helper = false \n\n    config.generators.stylesheets = false \n\n"
end

def source_paths
  [File.expand_path(File.dirname(__FILE__))]
end

console_puts('Installing RSpec.')
run "rails generate rspec:install"

console_puts('Converting view/layouts/application.html.erb HAML.')
generate "haml:application_layout convert"
run "rm app/views/layouts/application.html.erb"

console_puts('Converting assets for Bootstrap.')
run "rm app/assets/stylesheets/application.css"
run "rm app/assets/javascript/application.js"
run "curl https://raw.githubusercontent.com/lostphilosopher/rails_template/master/application.scss > app/assets/stylesheets/application.scss"
run "curl https://raw.githubusercontent.com/lostphilosopher/rails_template/master/application.js > app/assets/javascripts/application.js"

console_puts('Creating the database.')
rails_command "db:create"
run "rake db:migrate"

console_puts('Setting up Git.')
git :init
git add: "."
git commit: %Q{ -m 'Initial commit' }

console_puts('Build complete, happy Rails-ing!')
