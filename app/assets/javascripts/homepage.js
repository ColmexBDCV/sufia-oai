$(document).ready(function(){
  var random_number = Math.floor(Math.random()*(4-1+1)+1);
  var background_image = 'banner' + random_number + '.jpg';
  $('#home_header').css('background-image', 'url(image-path(' + background_image + '))');
   
  $('.overlay').width(300);
  $('.overlay').height(200);
  $('.img_overlay').height(200);
  $('.img_overlay').css("bottom",200);

  $('.overlay').mouseenter(function () {
    console.log("mouseenter" + this);
    $('.img_overlay', this).show("slide",{ direction : "down" },150);
  });

  $('.overlay').mouseleave(function () {
    console.log("mouseleave" +  this);
    $('.img_overlay', this).hide("slide",{direction : "down" },150);
  });
});
