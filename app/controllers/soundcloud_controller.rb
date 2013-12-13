class SoundcloudController < ApplicationController
  def connect
    redirect_to soundcloud_client.authorize_url(:display => "popup")
  end

  def connected
    if params[:error].nil?
      soundcloud_client.exchange_token(:code => params[:code])
      me = soundcloud_client.get("/me")

      login_as User.find_or_create_by_soundcloud_user_id({
        :soundcloud_user_id  => me.id,
        :soundcloud_username => me.username
      })

      current_user.update_attributes!({
        :soundcloud_access_token  => soundcloud_client.access_token,
        :soundcloud_refresh_token => soundcloud_client.refresh_token,
        :soundcloud_expires_at    => soundcloud_client.expires_at,
      })

      begin
        followed_id = "..." 
        follower_id = "..."
        following_id = "..."

        puts followed = soundcloud_client.get("/users/#{followed_id}") # Works if followed_id is me.id. Otherwise 401 - Unauthorized if exists, 404 - Not Found if not.
        puts follower = soundcloud_client.get("/users/#{followed_id}/followers/#{follower_id}") # 401 - Unauthorized if exists, 404 - Not Found if not. 
        puts following = soundcloud_client.get("/me/followings/#{following_id}") # Same as above.

      rescue SoundCloud::ResponseError => e
        puts e.response
      end
    end
    render :layout => false
  end

  def disconnect
    login_as nil
    redirect_to root_path
  end
  
private

  def soundcloud_client
    return @soundcloud_client if @soundcloud_client
    @soundcloud_client = User.soundcloud_client(:redirect_uri  => soundcloud_connected_url)
  end


end