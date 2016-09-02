$(document).ready(function(){
//var random_number = Math.floor(Math.random()*(4-1+1)+1);
//var background_image = 'banner' + random_number + '.jpg';
//$('#home_header').css('background-image', 'url(image-path(' + background_image + '))');

$('img.image_overlay').ready(function() {
var div_width = ($('img.image_overlay').width());
var div_height = ($('img.image_overlay').height());
$('div.overlay').width(div_width);
$('div.overlay').height(div_height);
$('.img_overlay').height(div_height);
$('.img_overlay').css("bottom",div_height);

$('div.overlay').mouseenter(function () {
console.log("mouseenter");
$('.img_overlay').show("slide",{ direction : "down" },150);
});
$('div.overlay').mouseleave(function () {
console.log("mouseleave");
$('.img_overlay').hide("slide",{direction : "down" },150);
});

});

$('img.byrd').ready(function() {
var div_width = ($('img.byrd').width());
var div_height = ($('img.byrd').height());
$('div.overlay_byrd').width(div_width);
$('div.overlay_byrd').height(div_height);
$('.img_overlay_byrd').height(div_height);
$('.img_overlay_byrd').css("bottom",div_height);

$('div.overlay_byrd').mouseenter(function () {
$('.img_overlay_byrd').show("slide",{ direction : "down" },150);
});
$('div.overlay_byrd').mouseleave(function () {
$('.img_overlay_byrd').hide("slide",{direction : "down" },150);
});

});

$('img.arch').ready(function() {
var div_width = ($('img.arch').width());
var div_height = ($('img.arch').height());
$('div.overlay_arch').width(div_width);
$('div.overlay_arch').height(div_height);
$('.img_overlay_arch').height(div_height);
$('.img_overlay_arch').css("bottom",div_height);

$('div.overlay_arch').mouseenter(function () {
$('.img_overlay_arch').show("slide",{ direction : "down" },150);
});
$('div.overlay_arch').mouseleave(function () {
$('.img_overlay_arch').hide("slide",{direction : "down" },150);
});

});
});
