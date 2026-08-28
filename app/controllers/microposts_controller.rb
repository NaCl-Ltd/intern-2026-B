class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user,   only: :destroy

  def create
    @micropost = current_user.microposts.build(micropost_params)
    @micropost.image.attach(params[:micropost][:image])
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_url
    else
      @feed_items = current_user.feed.paginate(page: params[:page])
      render 'static_pages/home', status: :unprocessable_content
    end
  end

  def destroy
    @micropost.destroy
    flash[:success] = "Micropost deleted"
    if request.referrer.nil?
      redirect_to root_url, status: :see_other
    else
      redirect_to request.referrer, status: :see_other
    end
  end

  def pin
    @micropost = current_user.microposts.find_by(id: params[:id])
    if @micropost.any?
      @pin_microposts = current_user.microposts.pinning
      if @pin_microposts.any?
        @pin_microposts.first.update(pinned: false)
      end
      @micropost.update(pinned: true)
    end
    redirect_to request.referrer || root_url, status: :see_other
  end

  def unpin
    @micropost = current_user.microposts.find_by(id: params[:id])
    if @micropost.any?
      @micropost.update(pinned: false)
    end
    redirect_to request.referrer || root_url, status: :see_other
  end

  private

    def micropost_params
      params.require(:micropost).permit(:content, :image)
    end

    def correct_user
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_url, status: :see_other if @micropost.nil?
    end
end
