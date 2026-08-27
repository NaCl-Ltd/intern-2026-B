class LikesController < ApplicationController
    before_action :logged_in_user

    def create
        current_user.likes.find_or_create_by(micropost_id: params[:micropost_id])
        redirect_back fallback_location: root_url
    end

    def destroy
        current_user.likes.find_by(micropost_id: params[:micropost_id])&.destroy
        redirect_back fallback_location: root_url
    end
end
