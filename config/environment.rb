# Load env vars first
env_file = File.expand_path("app_environment_variables.rb", __dir__)
load env_file if File.exist?(env_file)

# Load the Rails application.
require_relative "application"

# Initialize the Rails application.
Rails.application.initialize!
