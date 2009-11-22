class Admin::PostsController < ApplicationController   
  layout 'admin'
  before_filter :login_required
  access_control :DEFAULT => '(superuser | editor)'   
  before_filter { |c| c.set_section('manage_post') }      
  
  uses_tiny_mce :only => [:new, :create, :edit, :update,:show],
  :options => { :theme => 'advanced',:plugins => %w{ syntaxhl },:content_css => "/stylesheets/editor_content.css",
  :browsers => %w{msie gecko safari},
  :theme_advanced_layout_manager => "SimpleLayout",
  :theme_advanced_statusbar_location => "bottom",
  :theme_advanced_toolbar_location => "top",
  :theme_advanced_toolbar_align => "left",
  :theme_advanced_resizing => true,
  :relative_urls => false,
  :convert_urls => false,
  :cleanup => true,
  :cleanup_on_startup => true,  
  :convert_fonts_to_spans => true,
  :theme_advanced_resize_horizontal => false,
  :theme_advanced_buttons1 => %w{bold italic underline separator justifyleft justifycenter justifyright indent outdent separator bullist numlist separator link unlink image media separator  undo redo syntaxhl},
  :theme_advanced_buttons2 => [],
  :theme_advanced_buttons3 => [],
  :editor_deselector => "mceNoEditor"
  }
     
  def index
    @posts = Post.paginate :page => params[:page], :order => 'created_at ASC'
  end     
  
  
  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    
    respond_to do |wants|
      flash[:notice] = "帖子已删除"
      wants.html { redirect_to root_path }
    end    
  end
  
  def set_visibility
    @post = Post.find(params[:id])  
    
    respond_to do |wants|
      if @post.update_attributes(:visible => params[:visible])
        flash[:notice] = '操作成功!'
      else
        flash[:error] = '出错了'
      end
      wants.html { redirect_to @post }    
    end
  end

  def edit
    @post = Post.find(params[:id])  
    
    respond_to do |wants|
      wants.html {  }
    end
  end           
  
  def update
    @post = Post.find(params[:id]) 
    
    respond_to do |wants|  
      if @post.update_attributes(params[:post])   
        flash[:notice] = '帖子修改成功!'
        wants.html { redirect_to admin_posts_path }
      else
        wants.html { render :action => "edit" } 
      end
    end
  end
  
  def marktop
    @post = Post.find(params[:id])
    
    respond_to do |wants|
      if @post.update_attributes(:top => params[:mark_top])
        flash[:notice] = '操作成功!'
      else
        flash[:error] = '出错了'
      end
      wants.html { redirect_to @post }    
    end
  end
  
end
