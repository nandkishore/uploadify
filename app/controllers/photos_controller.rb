
class PhotosController < ApplicationController
  
  #before_filter :require_user
  before_filter :find_sku
  before_filter :find_or_build_photo
  
  def create
    respond_to do |format|
      unless @photo.save
        
        flash[:error] = 'Photo could not be uploaded'
      end
      format.js do
        render :text => render_to_string(:partial => 'photos/photo', :locals => {:photo => @photo})
      end
      format.json  { render json: "ok"} 
    end
  end

  def destroy
    respond_to do |format|
      unless @photo.destroy
        flash[:error] = 'Photo could not be deleted'
      end
      format.js  do
        render :text => render_to_string(:partial => 'photos/photo', :locals => {:photo => @photo})
      end
    end
  end

private
    
    def find_sku
      @sku = Sku.find(params[:sku_id])
      raise ActiveRecord::RecordNotFound unless @sku
    end
    
    def find_or_build_photo
      @photo = @sku.photos.build(:image => params[:file])
    end
end
