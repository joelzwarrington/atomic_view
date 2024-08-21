# frozen_string_literal: true

module AtomicView
  class Component < ViewComponent::Base
    include Heroicon::Engine.helpers

    alias_method :icon, :heroicon

    def class_names(...)
      classes = super
      TailwindMerge::Merger.new.merge(classes)
    end
  end
end
