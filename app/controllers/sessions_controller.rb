class SessionsController < ApplicationController
  
  def new 
    
  end
  
  def create
    chef = Chef.find_by(email: params[:session][:email].downcase)
    if chef && chef.authenticate(params[:session][:password])
      session[:chef_id] = chef.id
      flash[:success] = "You have successfully logged in."
      redirect_to chef  # this is a short form for chef_path(chef)
    else
      flash.now[:danger] = "There was something wrong with your log in information." # Flash is used to render when a new page is rendered. Here, the repeat of the "new" page is not a NEW page, and the flash message will be seen again during the next, actual NEW page. The 'now' attribute forces the flash message to render immediately.
                                                                                    # Further, we are forced to manually produce this message (as opposed to just using the errors partial), because the :session variable is not model-backed, which is necessary for doing a form.
      render 'new'
    end
  end
  
  def destroy
    session[:chef_id] = nil
    flash[:success] = "You have logged out."
    redirect_to root_path
  end
  
end