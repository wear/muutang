module PostsHelper
  def mark_top_button(post)                                     
    if post.top 
      pretty_button '取消置顶',marktop_admin_post_path(@post,:mark_top => :false),:method => :put
    else
      pretty_button '置顶',marktop_admin_post_path(@post,:mark_top => :true),:method => :put
   end
  end
end
