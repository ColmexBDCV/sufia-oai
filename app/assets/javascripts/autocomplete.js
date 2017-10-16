

var options = {

  url: function(phrase) {
    return "/client/persona_name?phrase="+phrase;
    // return "/client/persona_name";

  },

  getValue: function(element) {
    
  	return element.nombre;
  },

  list: {
    maxNumberOfElements: 10,
    // match: {
    //   enabled: true
    // }
  },

  theme: "square"
};


$(document).ready(function(){

  $('[id*="_creator"]').easyAutocomplete(options);

  $('[id*="_contributor"]').easyAutocomplete(options);

  $('.easy-autocomplete').removeAttr('style');
});
