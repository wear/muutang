// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults   

$(document).ready(function() { 
	setTimeout(function () { $('#flash-message').fadeOut(); }, 4000); 
});  

$(document).ready(function() { 
   	$(".box").addClass("ui-corner-all");
});

$(document).ready(function() { 
	$("input[type='submit']").mouseover(function(){
	        $("input[type='submit']").addClass("hover_btn");
	 }).mouseout(function(){
			 $("input[type='submit']").removeClass("hover_btn");
	  });
});
