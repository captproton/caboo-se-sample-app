class ImagesController < ApplicationController

  before_filter :user
  before_filter :image, :only => [ :show, :edit, :update, :delete ]
  before_filter :login_required, :only => [ :edit, :update, :delete, :new, :create ]

protected 
  helper_method :image
  def image
    @image ||= user.images.find(params[:id]) or raise ActiveRecord::RecordNotFound
  end
  
  helper_method :user
  def user
    @user ||= User.find_by_login(params[:user_id])
  end

  def authorized?
    return true unless protected_action?
    return true if protected_action? and @user == current_user
    raise AccessDenied
  end

public

# member actions
  
  def show
    image
  end

# new members

  def new
  end
  
  def create
    @image = current_user.images.create(params[:image])
    redirect_to [current_user, @image]
  rescue ActiveRecord::RecordInvalid
    render :action => 'new'
  end

# existing members

  def edit
  end
  
  def update
    image.update_attributes(params[:image])
    redirect_to [image.user, image]
  rescue ActiveRecord::RecordInvalid
    render :action => 'edit'
  end
  
 
# collection actions
 
  def index
    @images = user.images.paginate :all, :page => params[:page]
  end
  
end