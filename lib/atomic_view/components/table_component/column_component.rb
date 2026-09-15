# frozen_string_literal: true

module AtomicView
  module Components
    class TableComponent
      # TableComponent::Column
      #
      # One <th> in the header row TableComponent auto-renders once at
      # least one `with_column` is given -- see TableComponent's docs.
      #
      # `label` defaults to `model.human_attribute_name(attribute)`
      # (mirroring Rails' own form label defaulting) when a `model:` is
      # given -- TableComponent passes its own `model:` through to every
      # column automatically, so callers only need `attribute:`. Pass
      # `label:` directly instead for a column with no backing
      # attribute (e.g. a blank header over a row of "Edit" links).
      class ColumnComponent < AtomicView::Component
        attr_reader :model, :attribute, :align, :width

        def initialize(model: nil, attribute: nil, label: nil, align: :left, width: nil)
          super()
          raise ArgumentError, "label is required when model is not given" if model.nil? && label.nil?

          @model = model
          @attribute = attribute
          @label = label
          @align = align
          @width = width
        end

        def label
          @label || model.human_attribute_name(attribute)
        end

        def call
          tag.th(label, scope: "col", class: header_class)
        end

        private

        def header_class
          class_names("p-2 font-medium", align_class, width)
        end

        def align_class
          case align
          when :center then "text-center"
          when :right then "text-right"
          end
        end
      end
    end
  end
end
