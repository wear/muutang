TINYIMC = { :theme => 'advanced',
:browsers => %w{msie gecko safari}, 
:content_css => "/stylesheets/editor_content.css",
:cleanup_on_startup => true,
:convert_fonts_to_spans => true,
:theme_advanced_resizing => true, 
:theme_advanced_toolbar_location => "top",  
:theme_advanced_statusbar_location => "bottom", 
:editor_deselector => "mceNoEditor",
:theme_advanced_resize_horizontal => false,  
:theme_advanced_buttons1 => %w{bold italic underline separator bullist numlist separator link unlink image},
:theme_advanced_buttons2 => [],
:theme_advanced_buttons3 => [],
:plugins => %w{syntaxhl}  
}     

ADVTINYIMC = { :theme => 'advanced',
:browsers => %w{msie gecko safari}, 
:content_css => "/stylesheets/editor_content.css",
:cleanup_on_startup => true,
:convert_fonts_to_spans => true,
:theme_advanced_resizing => true, 
:theme_advanced_toolbar_location => "top",  
:theme_advanced_statusbar_location => "bottom", 
:editor_deselector => "mceNoEditor",
:theme_advanced_resize_horizontal => false,  
:theme_advanced_buttons1 => %w{bold italic underline blockquote separator justifyleft justifycenter justifyright indent outdent separator bullist numlist separator link unlink image media separator undo redo code},  
:theme_advanced_buttons2 => [],
:theme_advanced_buttons3 => [],
:plugins => %w{syntaxhl},  
:extended_valid_elements => "img[class|src|flashvars|border=0|alt|title|hspace|vspace|width|height|align|onmouseover|onmouseout|name|obj|param|embed|scale|wmode|salign|style],embed[src|quality|scale|salign|wmode|bgcolor|width|height|name|align|type|pluginspage|flashvars],object[align<bottom?left?middle?right?top|archive|border|class|classid|codebase|codetype|data|declare|dir<ltr?rtl|height|hspace|id|lang|name|style|tabindex|title|type|usemap|vspace|width]" 
}        

SSALARY = [ 
  ['?'],
  ['3k以内'],
  ['3k-5k'],
  ['5k-8k'],
  ['8k-1.2w'],
  ['上不封顶']
  ]