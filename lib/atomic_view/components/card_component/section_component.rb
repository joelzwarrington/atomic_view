# frozen_string_literal: true

module AtomicView
  module Components
    class CardComponent
      # CardComponent::Section
      #
      # One row of a sectioned card -- see CardComponent's docs. Just a
      # padded, free-form content block; CardComponent's `divide-y` wrapper
      # is what adds the border between sections, not this component.
      class SectionComponent < AtomicView::Component
        def initialize(**options)
          super()
          @options = options
        end

        def call
          tag.div(**@options.except(:class), class: class_names(CardComponent::PADDING_CLASSES, @options[:class])) { content }
        end
      end
    end
  end
end
