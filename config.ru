# This file is used by Rack-based servers to start the application.

require_relative 'config/environment'
require_relative "config/application"
require "rack/method_override"

use Rack::MethodOverride


run Rails.application
