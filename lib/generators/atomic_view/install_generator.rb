# frozen_string_literal: true

module AtomicView
  class InstallGenerator < Rails::Generators::Base
    source_root File.expand_path("templates", __dir__)

    IMPORT = '@import "../builds/tailwind/atomic_view.css";'
    FLOATING_UI_PIN = 'pin "@floating-ui/dom", to: "https://cdn.jsdelivr.net/npm/@floating-ui/dom@1.8.0/+esm"'

    def add_atomic_view_tailwind
      return if options[:update_tailwind_only]

      tailwind_path = Rails.root.join("app/assets/tailwind/application.css")
      unless tailwind_path.exist?
        raise "`app/assets/tailwind/application.css` does not exist"
      end

      if tailwind_path.read.include?(IMPORT)
        puts "`app/assets/tailwind/application.css` already contains `#{IMPORT}`"
      else
        insert_into_file tailwind_path, after: '@import "tailwindcss";' do
          "\n#{IMPORT}\n"
        end
      end
    end

    def add_atomic_view_js_controllers
      return if options[:update_tailwind_only]

      controllers_path = Rails.root.join("app/javascript/controllers/index.js")
      if controllers_path.exist? && controllers_path.read.include?('eagerLoadControllersFrom("controllers", application)')
        if controllers_path.read.include?('eagerLoadControllersFrom("atomic_view", application)')
          puts '`app/javascript/controllers/index.js` already contains `eagerLoadControllersFrom("atomic_view", application)`'
        else
          insert_into_file controllers_path, after: 'eagerLoadControllersFrom("controllers", application)' do
            "\neagerLoadControllersFrom(\"atomic_view\", application)\n"
          end
        end
      else
        puts '`app/javascript/controllers/index.js` does not exist or does not contain `eagerLoadControllersFrom("controllers", application)`'
      end
    end

    def add_atomic_view_floating_ui
      return if options[:update_tailwind_only]

      importmap_path = Rails.root.join("config/importmap.rb")
      if importmap_path.exist? && importmap_path.read.match?(/^pin\s+["']application["']/)
        if importmap_path.read.include?(FLOATING_UI_PIN)
          puts "`config/importmap.rb` already contains the `@floating-ui/dom` pin"
        else
          insert_into_file importmap_path, after: /^pin\s+["']application["'].*\n/ do
            "#{FLOATING_UI_PIN}\n"
          end
        end
      else
        puts '`config/importmap.rb` does not exist or does not contain `pin "application"`'
      end
    end
  end
end
