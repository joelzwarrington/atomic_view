# frozen_string_literal: true

module AtomicView
  def self.post_install
    puts 'AtomicView: Running post install tasks...'
  rescue StandardError => e
    puts "AtomicView: Failed to update Tailwind configuration. Error: #{e.message}"
    puts "You may need to run 'bin/rails atomic_view:install' manually to complete the setup."
  end
end
