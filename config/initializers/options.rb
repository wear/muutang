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

SSALARY = [ 
  ['?'],
  ['3k以内'],
  ['3k-5k'],
  ['5k-8k'],
  ['8k-1.2w'],
  ['上不封顶']
  ]