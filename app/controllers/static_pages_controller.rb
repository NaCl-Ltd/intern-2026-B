class StaticPagesController < ApplicationController

  def home
    if logged_in?
      @micropost  = current_user.microposts.build
      @feed_items = current_user.feed.notpinning_feed(current_user.id).paginate(page: params[:page])
      @pin_microposts = current_user.microposts.pinning
    end
  end

  def help
  end

  def about
  end

  def contact
  end
end
