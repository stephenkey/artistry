class AlbumsController < ApplicationController
  before_action :authenticate_user!

  def index
    @albums = Album.search(params[:q])
    respond_to do |format|
      format.html
      format.js
    end
  end

  def search
    @albums = Album.search(params[:q])
    respond_to do |format|
      format.html
      format.js
    end
  end

  def mine
    @libraries = current_user.libraries.includes(album: [:artist, :images])
  end

  def create
    Album.find_and_assign(params[:artist], params[:album], current_user.id)
  end

  def show
    @library = current_user.libraries.includes(album: [:artist, :images, :tracks]).find(params[:id])
  end

  def edit
    @library = current_user.libraries.includes(:album).find(params[:id])
  end

  def update
    @library = current_user.libraries.find(params[:id])
    @library.update(state: params[:library][:state])
    respond_to do |format|
      format.html { redirect_to album_path(@library), flash: { success: "You have successfully updated your album." } }
    end
  end

  def destroy
    @library = current_user.libraries.find(params[:id])
    @library.destroy
    respond_to do |format|
      format.html { redirect_to mine_albums_path, flash: { success: "Album has been removed." } }
    end
  end

end
