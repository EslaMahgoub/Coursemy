class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:edit, :update, :show]
  
  rescue_from Pagy::OverflowError, with: :redirect_to_last_page

  def index
    #@users = User.all.order(created_at: :desc)
    
    @q = User.ransack(params[:q])
    #@users = @q.result(distinct: true)
    @pagy, @users = pagy(@q.result(distinct: true))
    authorize @users
  end 
  
  def show
  end
  
  def edit
    authorize @user
  end
  
  def update
    authorize @user
    if @user.update(user_params)
      redirect_to users_path, notice: "User #{@user.email} was successfully updated."
    else
      render :edit
    end
  end
  
  def set_user
    @user = User.friendly.find(params[:id])
  end
  
  def user_params
    params.require(:user).permit({role_ids: []})
  end
  
  private

  # Throw exception if number of items in list < Pagy::VARS[:items] instead of throwing Overflow error
  def redirect_to_last_page(exception)
    redirect_to url_for(page: exception.pagy.last), notice: "Page ##{params[:page]} is overflowing. Showing page #{exception.pagy.last} instead."
  end

end