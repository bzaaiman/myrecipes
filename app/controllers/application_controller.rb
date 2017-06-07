class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
 
  helper_method :current_chef, :logged_in?  # This makes the stipulated methods avaiable in views also, and not just in controllers.
  
  def current_chef
    # Because this is called a lot, it is optimized. The ||= operator (OR EQUALS) works as follows, if @current_chef exists return it and stop. If not, assign it the next value if it exists. Else, nil.
    # This prevents the method from hitting the database every time it is called, which is a lot. It only hits the db if the @current_chef is nil.
    @current_chef ||= Chef.find(session[:chef_id]) if session[:chef_id]  # Ruby returns the value of the last line of a method to the caller
  end
  
  def logged_in?
    !!current_chef # The !! (BANG BANG) operator turns any variable into a true or false operator. Does it exist? True. Does it not exist? False.
  end
  
  def require_user # This method is only used in the controller, and not the views.
    if !logged_in? # ! means NOT.
      flash[:danger] = "You must be logged in to perform that action"
      redirect_to root_path
    end
  end
  
end
