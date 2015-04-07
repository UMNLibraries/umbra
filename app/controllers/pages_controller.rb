class PagesController < ApplicationController

  include FeaturedImagesHelper

  def home
    if params[:featured_image]
      @featured_image = FeaturedImage.find(params[:featured_image])
    else
      @featured_image = random_featured_image
    end
  end

  def about
  end

  def history
  end

  def participating
  end

  def copyright
  end

  def team
  end

  def contact
  end

  def participate
  end
end
