# frozen_string_literal: true

module HeroiconHelper
  include Heroicon::Engine.helpers

  alias_method :icon, :heroicon
end
