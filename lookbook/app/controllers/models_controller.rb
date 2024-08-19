class ModelsController < ApplicationController
  protect_from_forgery with: :null_session

  def create
    redirect_back(fallback_location: lookbook_path)
  end
end
