# frozen_string_literal: true

module AtomicView
  module Components
    class AvatarComponent < AtomicView::Component
      attr_reader :src, :initials, :size

      def initialize(src: nil, initials: nil, size: :md, **options)
        super()
        @src = src
        @initials = initials
        @size = size
        @options = options
      end

      def call
        if src.present?
          tag.img(**@options.except(:class), class: class_names("rounded-full object-cover", size_classes, @options[:class]), src: src)
        else
          tag.span(**@options.except(:class), class: class_names("flex items-center justify-center rounded-full bg-offset text-foreground font-medium", size_classes, text_size_classes, @options[:class])) { initials }
        end
      end

      private

      def size_classes
        case size
        when :sm
          "size-6"
        when :lg
          "size-10"
        else
          "size-8"
        end
      end

      def text_size_classes
        case size
        when :sm
          "text-xs"
        when :lg
          "text-base"
        else
          "text-sm"
        end
      end
    end
  end
end
