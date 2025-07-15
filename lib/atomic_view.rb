# frozen_string_literal: true

require 'atomic_view/version'
require 'atomic_view/engine'
require 'atomic_view/configuration'

require "tailwind_merge"
require "heroicons"
require "view_component"
require "view_component/form"
require "zeitwerk"
loader = Zeitwerk::Loader.for_gem
loader.ignore("#{__dir__}/generators")
loader.setup

module AtomicView
  class << self
    attr_accessor :configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield(configuration)
  end

  def self.post_install
    puts 'AtomicView: Running post install tasks...'
  rescue StandardError => e
    puts "AtomicView: Failed to update Tailwind configuration. Error: #{e.message}"
    puts "You may need to run 'bin/rails atomic_view:install' manually to complete the setup."
  end
end

ViewComponent::Form.configure do |config|
  config.parent_component = "AtomicView::Component"
end
