module WikisHelper      
  # Return true if user is authorized for wiki, otherwise false
  def authorize_for(group)
    current_user
  end
  
  # Display a link if user is authorized
  def link_to_if_authorized(group,name, options = {}, html_options = nil, *parameters_for_method_reference)
    link_to(name, options, html_options, *parameters_for_method_reference) if authorize_for(group)
  end

  # Display a link to remote if user is authorized
  def link_to_remote_if_authorized(name, options = {}, html_options = nil)
    url = options[:url] || {}
    link_to_remote(name, options, html_options) if authorize_for(url[:controller] || params[:controller], url[:action])
  end       
  
  def other_formats_links(&block)
    concat('<p class="other-formats">')
    yield Views::OtherFormatsBuilder.new(self)
    concat('</p>')
  end
  
end
