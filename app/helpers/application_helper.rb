module ApplicationHelper
  
# Use helpers for methods that you will only use in views. If your method has wider applicability, e.g. user authentication, place them in ApplicationController.
  
  def gravatar_for(user, options = { size: 80 })
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    size = options[:size]
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag(gravatar_url, alt: user.chefname, class: "img-circle")
  end
  
end
