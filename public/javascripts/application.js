// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

Event.observe(document, 'dom:loaded', function() {
  $$('.linkable').each(function(tbody){
    Event.observe(tbody, 'click', function(e){
      window.location.href = $(this).down('a').href;
    }) // tbody click
  }) // linkable event
}) // contentLoaded