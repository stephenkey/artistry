class ArtistsController < ApplicationController

  def index
    respond_to do |format|
      format.html { @artists = Artist.includes(albums: [:images, :tracks]) }
      format.csv { send_data Artist.to_csv }
    end
  end

  def show
    @artist = Artist.includes(albums: [:images, :tracks]).find(params[:id])
    respond_to do |format|
      format.html
    end
  end

end
