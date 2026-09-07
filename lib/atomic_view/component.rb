# frozen_string_literal: true

module AtomicView
  class Component < ViewComponent::Base
    include Heroicons::Engine.helpers
    include LocalTimeHelper

    def icon(name, variant: Heroicons.configuration.variant, options: {}, path_options: {})
      raw Heroicons::Icon.render( # rubocop:disable Rails/OutputSafety
        name: name,
        variant: variant,
        options: options,
        path_options: path_options
      )
    end

    def class_names(...)
      classes = super
      TailwindMerge::Merger.new.merge(classes)
    end
  end
end
