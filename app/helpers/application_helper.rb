# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper      
  
  def pretty_button(text,link,options = {})  
    deftault_options = options.reverse_merge!(:class=>'btn')
    link_to content_tag(:span,content_tag(:span,text)),link,deftault_options
  end
  
  def long_pretty_button(text,link,link_option = {},options = { })
    content_tag(:button,
      content_tag(:span,
        content_tag(:span,
          link_to(text,link,link_option))),
    options)
  end
  
  def time_ago_in_words_or_date(date)
    if date.to_date.eql?(Time.now.to_date)
      display = I18n.l(date.to_time, :format => :time_ago)
    elsif date.to_date.eql?(Time.now.to_date - 1)
      display = '昨天'
    else
      display = I18n.l(date.to_date, :format => :date_ago)
    end
  end
  
  def state_type(type)
    (type == 'error') ? 'error' : 'highlight'
  end  
  
  def cate(post)
    post.category.nil? ? '未分类' : post.category.name
  end  
  
  def current_category(cate)
    cate.nil? ? 0 : cate
  end
  
  def user_title(user)
      content_tag(:span," #{user.profile.title} ",:class => 'time') if user.profile.title
  end  
  
  def comment_status(comment)
    post = comment.commentable
    if post.comments.last.user == comment.user
        "暂无新评论" 
        else
        '有新的评论了' + link_to('去看看',post,:class => 'a2')
    end
  end    
  
  def topnav_tab(name, options)
    classes = [options.delete(:class)]
    classes << 'current' if options[:section] && (options.delete(:section).to_a.include?(@section))
    
    "<li class='#{classes.join(' ')}'>" + link_to( "<span>"+name+"</span>", options.delete(:url), options) + "</li>"
  end          
  
  def cate_lable(post)
    return nil if post.category.nil? 
    case post.category.name
    when '话题'
      '说'
    when '问答'
      '问'
    when '资源共享'
      '发布了'
    end
  end
  
end
