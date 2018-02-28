

var options = {

  url: function(phrase) {
    return "/client/autor?phrase="+phrase;
    // return "/client/persona_name";

  },

  getValue: function(element) {

    //console.log(element);

  	return element.nombre;
  },

  list: {
    maxNumberOfElements: 10,
    // match: {
    //   enabled: true
    // }
    onSelectItemEvent: function(evt) {
			var orcid = $(':focus').getSelectedItemData().orcid;
      var cvu = $(':focus').getSelectedItemData().cvu;
      $(':focus').parent().parent().next().children('input').val(orcid).trigger("change");
      $(':focus').parent().parent().next().next().children('input').val(cvu).trigger("change");
		}
  },

  theme: "square"
};


$(document).on('turbolinks:load',function(){

  // $('[name*="creator_conacyt]"]').easyAutocomplete(options);

  // $('[name*="contributor_conacyt]"]').easyAutocomplete(options);

  // $('.easy-autocomplete').removeAttr('style');




});
