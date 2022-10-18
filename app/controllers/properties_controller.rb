class PropertiesController < ApplicationController
  before_action :set_property, only: %i[ show edit update destroy action approve_listing ]

  def index
   
    if request.path == root_path || request.path==search_path || request.path==unapproved_listings_properties_path || request.path==pending_listings_properties_path 

      properties = if params[:q].present? && request.path == serch_path
        current_user.properties.where("appartment_name LIKE ? ", "%#{params[:q]}%")
      elsif params[:q].present? || request.path==search_path
        Property.approved.where("appartment_name LIKE ? ", "%#{params[:q]}%")
      elsif request.path == properties_path
        current_user.properties     
      elsif request.path == pending_listings_properties_path 
        Property.unapproved 
      elsif request.path == unapproved_listings_properties_path 
        current_user.properties.unapproved 
      elsif request.path == current_listings_properties_path 
        current_user.properties.approved 
      elsif request.path==root_path
        Property.approved
      end
      @pagy, @properties = pagy(properties)
    else    
      @q = current_user.properties.approved.ransack(params[:q])
      @pagy, @properties = pagy(@q.result(distinct: true))
    end
  end
 
  def show
    authorize! :show, @property
   
  end

  def upload
    uploaded_file = params[:image]
    File.open(Rails.root.join('public', 'uploads', uploaded_file.original_filename), 'wb') do |file|
      file.write(uploaded_file.read)
    end
  end

  def new
    @property = current_user.properties.new
   
  end

   def profile
     @property = current_user.properties
     if params[:q].present?
      @property=current_user.properties.where("appartment_name LIKE ? ", "%#{params[:q]}%")
     end
   end

  def approve_listing
    respond_to do |format|
      if @property.update(approved: true)
        format.html { redirect_to  pending_listings_properties_url, notice: "Property was successfully updated." }
        format.json { render :action, status: :ok, location: @property }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @property.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    authorize! :update, @property
  end

  def create
    @property = current_user.properties.new(property_params)
    
    if current_user.has_role? :admin
      @property.approved = true
    end

    respond_to do |format|
      if @property.save
        # format.turbo_stream do
        #   render turbo_stream: turbo_stream.append(:properties, partial: "properties/property",
        #     locals: { property: property }) 
        #   end
        format.html { redirect_to property_url(@property), notice: "Property was successfully created." }
        format.json { render :show, status: :created, location: @property }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @property.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @property.update(property_params)
        render turbo_stream:[
          turbo_stream.update(properties_url(@properties))
        ]
        # format.html { redirect_to  property_url(@property), notice: "Property was successfully updated." }
        # format.json { render :show, status: :ok, location: @property }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @property.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    authorize! :update, @property
    @property.destroy

    # respond_to do |format|
    #   format.html { redirect_to properties_url, notice:   "Property was successfully destroyed." }
    #   format.json { head :no_content }
    # end
    render turbo_stream:[
      turbo_stream.remove(@properties)
    ]
  end

  private
    def set_property
      @property = Property.find(params[:id]) 
    end

    def property_params
      params.require(:property).permit(:appartment_name, :construction_status, :bedrooms, :bathrooms, :price, :listed_by, :parking, :garden, :user_id, picture: [])
    end
end
