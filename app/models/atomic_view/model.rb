module AtomicView
  class Model
    include ActiveModel::Model

    attr_reader :attribute
  end
end
