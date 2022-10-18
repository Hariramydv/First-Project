class UsersController < ApplicationController
  # load_and_authorize_resource
  def index; end
  def about; end
  def contact; end
  def destroy; end

  def home
   respond_to do |format|
    format.html { redirect_to properties_path }
   end

  end

end
