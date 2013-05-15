require 'rubygems'
require 'csv'
#require 'rubyzip'
require 'zip/zip'
require 'zip/zipfilesystem'

class SkusController < ApplicationController
  # GET /skus
  # GET /skus.json
  def index
    @skus = Sku.all
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @skus }
    end
  end
  
  # GET /skus/1
  # GET /skus/1.json
  def show
    @sku = Sku.find(params[:id])
    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @sku }
    end
  end
  
  # GET /skus/new
  # GET /skus/new.json
  def new
    @sku = Sku.new
    
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @sku }
    end
  end
  
  # GET /skus/1/edit
  def edit
    @sku = Sku.find(params[:id])
  end

  # POST /skus
  # POST /skus.json
  def create
    @sku = Sku.new(params[:sku])
    @photo = Photo.new
    respond_to do |format|
      if @sku.save
        format.html { redirect_to @sku, notice: 'Sku was successfully created.' }
        format.json { render json: @sku, status: :created, location: @sku }
      else
        format.html { render action: "new" }
        format.json { render json: @sku.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /skus/1
  # PUT /skus/1.json
  def update
    @sku = Sku.find(params[:id])
    
    respond_to do |format|
      if @sku.update_attributes(params[:sku])
        format.html { redirect_to @sku, notice: 'Sku was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @sku.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # DELETE /skus/1
  # DELETE /skus/1.json
  def destroy
    @sku = Sku.find(params[:id])
    @sku.destroy
    
    respond_to do |format|
      format.html { redirect_to skus_url }
      format.json { head :no_content }
    end
  end
    
  def upload 
    @dump = Sku.new
    if !params[:file].nil?
      data = params[:file].read
      @parsed_file=CSV.parse(data)
      n=0
      @parsed_file.each  do |row|
        row.each do |x|
          sku = Sku.new(:code => x.gsub("\s", ""))
          sku.save if sku.valid?
        end
        flash.now[:message]="CSV Import Successful,  #{n} new records added to data base"
      end
    end
    redirect_to skus_path
  end
  
  
  def download_all
    @sku = Sku.find(params[:id])
    attachments = @sku.photos
    
    zip_file_path = "#{Rails.root}/public/#{@sku.code}.zip"
    
    
    # see if the file exists already, and if it does, delete it.
    if File.file?(zip_file_path)
      File.delete(zip_file_path)
    end
    
    
    # open or create the zip file
    Zip::ZipFile.open(zip_file_path, Zip::ZipFile::CREATE) { |zipfile|
      
      attachments.each do |attachment|
        #document_file_name shd contain filename with extension(.jpg, .csv etc) and url is the path of the document.
        url = "#{Rails.root}/public" + attachment.image.url
        zipfile.add( attachment.image.file.filename , url) 
        
      end
      
    } 
    #send the file as an attachment to the user.
    send_file zip_file_path, :type => 'application/zip', :disposition => 'attachment', :filename => "#{@sku.code}.zip"
  end

  def delete_all
    Sku.destroy_all
    respond_to do |format|
      format.html { redirect_to root_url }
      format.json { head :no_content }
    end
  end

  def download_all_images
    skus = Sku.find(:all)
    zip_file_path = "#{Rails.root}/public/all_images.zip"
    if File.file?(zip_file_path)
      File.delete(zip_file_path)
    end
    skus.each do |sku|
      attachments = sku.photos
      Zip::ZipFile.open(zip_file_path, Zip::ZipFile::CREATE) { |zipfile|
        attachments.each do |attachment|
          url = "#{Rails.root}/public" + attachment.image.url
          zipfile.add( attachment.image.file.filename , url) 
        end
      } 
    end
    send_file zip_file_path, :type => 'application/zip', :disposition => 'attachment', :filename => "all_images.zip"
  end
end
