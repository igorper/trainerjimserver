class Utils::AssetsController < ApplicationController
  # @param    name  the logical path to the asset.
  # @method   GET
  # @redirects      to the asset
  def asset
    redirect_to ActionController::Base.helpers.asset_path(params[:name])
  end
end
