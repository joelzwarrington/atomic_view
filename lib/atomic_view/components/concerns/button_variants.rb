# frozen_string_literal: true

module AtomicView
  module Components
    module Concerns
      module ButtonVariants
        private

        def base_classes
          "h-7 rounded-btn px-2.5 inline-flex items-center justify-center gap-2 whitespace-nowrap text-sm font-medium transition-all disabled:pointer-events-none disabled:opacity-50 outline-none focus-visible:border-ring focus-visible:ring-ring/50 focus-visible:ring-[3px]"
        end

        def variant_classes
          case variant
          when :primary
            "bg-primary text-primary-foreground shadow-xs hover:bg-primary/90"
          when :secondary
            "bg-secondary text-secondary-foreground shadow-xs hover:bg-secondary/80"
          when :destructive
            "bg-destructive text-destructive-foreground shadow-xs hover:bg-destructive/90 focus-visible:ring-destructive/20"
          when :muted
            "bg-transparent text-muted-foreground hover:bg-muted"
          when :link
            "text-primary underline-offset-4 hover:underline"
          when :outline
            "bg-surface text-foreground border-[1.5px] border-border hover:bg-offset"
          else
            "bg-primary text-primary-foreground shadow-xs hover:bg-primary/90"
          end
        end
      end
    end
  end
end
