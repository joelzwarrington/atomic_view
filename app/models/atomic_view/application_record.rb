# frozen_string_literal: true

module AtomicView
  class ApplicationRecord < ActiveRecord::Base
    self.abstract_class = true
  end
end
