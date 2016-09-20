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
//= require turbolinks
//= require blacklight/blacklight
//= require jquery.nested-fields
//= require cocoon
//= require sufia
//= require homepage
//= require_tree .

var ready = function() {
  $('#material-fields').nestedFields();
  $('#measurement-fields').nestedFields();

  $('.select2-field').select2();

  var random_number = Math.floor(Math.random()*(3-1+1)+1);
  var home_header_id = 'home_header_' + random_number;
  $('#home_header').attr("id",home_header_id);

  var footer_height = $('footer.footer').height();
  $('body').css('margin-bottom', footer_height);

  $(window).resize(function(){
    var footer_height = $('footer.footer').height();
    $('body').css('margin-bottom', footer_height);
  });
};

$(document).on('turbolinks:load', ready);
