module AdminHelper  
  def set_sort(column,pra)
    return (column + "-desc") if pra.nil?
    case pra.gsub(/.*-/,'')
      when "desc"
        column + "-asc" 
      when "asc"
        column + "-desc"
      else
        column + "-desc"
    end 
  end    
  
  def sort_type(section,pra)   
    if !pra.nil? && (pra.gsub(/-.*/,'') == section) 
      pra.gsub(/.*-/,'') 
    else 
      "sorting"   
    end
  end    
  
  def sortable_link(name,url,column)         
    link_to(name,(url + "?sitem=#{set_sort(column,params[:sitem])}"),
    :class =>sort_type(column,params[:sitem]))
  end
  
end
