class ApplicationController < ActionController::Base
  include Authentication
  allow_browser versions: :modern
  before_action :set_profile_and_banner_images

  private

  def set_profile_and_banner_images
    @setting = Rails.cache.fetch("site_setting") do
      Setting.first
    end
  end
end
