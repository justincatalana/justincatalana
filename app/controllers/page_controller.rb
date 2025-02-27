class PageController < ApplicationController
  def home
    setting = Setting.first
    @profile_image = setting&.profile_image&.attached? ? setting.profile_image : nil
    @banner_image = setting&.profile_image&.attached? ? setting.profile_image : nil
  end
  def subscribe
  end
end
