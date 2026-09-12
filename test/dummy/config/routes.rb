# frozen_string_literal: true

Rails.application.routes.draw do
  get "up" => "rails/health#show", :as => :rails_health_check

  # A real ActiveRecord + Turbo Streams demo of GanttComponent -- see
  # RentalsController. Declared before the Lookbook mount below, since
  # Lookbook is mounted at "/" and (being itself a catch-all for its own
  # 404 handling) would otherwise swallow every request before it ever
  # reaches these.
  resources :rentals, only: :index
  get "rentals/dates", to: "rentals#dates", as: :rentals_dates

  mount Lookbook::Engine, at: '/'
  resource :models, only: :create
end
