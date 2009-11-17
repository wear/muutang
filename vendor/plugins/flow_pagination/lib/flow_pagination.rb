module FlowPagination

  # FlowPagination renderer for (Mislav) WillPaginate Plugin
  class LinkRenderer < WillPaginate::LinkRenderer

    # Render flow navigation
    def to_html
      flow_pagination = ''

      if self.current_page < self.last_page
        flow_pagination = @template.link_to_remote(
            @template.t('flow_pagination.button', :default => '载入更多'),  
            :url => { :controller => @template.controller_name,
            :action => @template.action_name,
            :params => @template.params.merge!(:page => self.next_page)}, 
            :loading => "$('#flow_pagination_#{@options[:class]}').hide();$('.activate').show();",
            :complete => "$('#flow_pagination_#{@options[:class]}').show();$('.activate').hide();; 
            ",       
            :method => @template.request.request_method,
            :html => { :class  => "post-more" } )
      end
      
      #hardcoding, need improve
      @template.content_tag(:div, flow_pagination, :id => "flow_pagination_#{@options[:class]}")

    end

    protected

      # Get current page number
      def current_page
        @collection.current_page
      end

      # Get last page number
      def last_page
        @last_page ||= WillPaginate::ViewHelpers.total_pages_for_collection(@collection)
      end

      # Get next page number
      def next_page
        @collection.next_page
      end

  end

end
