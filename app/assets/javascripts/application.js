// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require js-routes
//= require jquery
//= require jquery-ui
//= require jquery_ujs
// require turbolinks
//= require chosen-jquery
//= require blacklight/blacklight
//= require jquery.nested-fields
//= require owl.carousel
//= require cocoon
//= require sufia
//= require homepage
//= require_tree .
$(document).ready(function(){

  $('#material-fields').nestedFields();
  $('#measurement-fields').nestedFields();

  $('.select2-field').select2();

  // using chosen gem for import field mappings (can select multiple)
  $('.chosen-select').chosen({
    allow_single_deselect: true,
    no_results_text: 'No results matched',
    disable_search_threshold: 8,
    width: '100%'
  });

  // using chosen gem import field mappings for image (can only select one)
  $('.chosen-select-max-1').chosen({
    allow_single_deselect: true,
    no_results_text: 'No results matched',
    max_selected_options: 1,
    width: '100%'
  });

});
