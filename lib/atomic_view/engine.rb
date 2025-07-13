# frozen_string_literal: true

require 'importmap-rails'

module AtomicView
  class Engine < ::Rails::Engine
    isolate_namespace AtomicView

    initializer 'local_helper.action_controller' do
      ActiveSupport.on_load :action_controller do
        helper AtomicView::HeroiconsHelper
      end
    end

    initializer 'atomic_view.tailwindcss' do |app|
      ActiveSupport.on_load(:tailwindcss_rails) do
        config.tailwindcss_rails.engines << AtomicView::Engine.engine_name
      end
    end


    initializer 'atomic_view.importmap', before: 'importmap' do |app|
      app.config.importmap.paths << root.join('config/importmap.rb')
      app.config.importmap.cache_sweepers << root.join('app/assets/javascripts')
    end

    initializer 'atomic_view.assets' do |app|
      app.config.assets.precompile += %w[atomic_view_manifest]
    end

    initializer 'atomic_view.precompile' do |app|
      app.config.assets.paths << root.join('app/assets/javascripts')
      app.config.assets.precompile << 'atomic_view/application.js'
      app.config.assets.paths << root.join('app/assets/dist')
      app.config.assets.precompile << 'atomic_view/tailwind.css'
    end
  end
end
