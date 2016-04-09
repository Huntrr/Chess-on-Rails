class FriendshipsController < ApplicationController
  before_action :set_friendship, only: [:show, :accept, :destroy]

  # POST /friendships/1
  def create
    current_user.send_friend_request params[:friend_id]
    friend = User.find(params[:friend_id])
    redirect_to friend, notice: 'Friend request sent'
  end

  # PATCH /friendships/1
  def accept
    current_user.accept_friend_request @friendship.user
    redirect_to current_user, notice: 'Friend request accepted'
  end

  # DELETE /friendships/1
  # DELETE /friendships/1.json
  def destroy
    other = Friendship.find_by(user: @friendship.friend, friend: @friendship.user)
    other.destroy unless other.nil?
    @friendship.destroy
    respond_to do |format|
      format.html { redirect_to current_user, notice: 'Friendship was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_friendship
      @friendship = Friendship.find(params[:id])
    end
end
