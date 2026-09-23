jQuery(window).load(function () {
    
    jQuery("input:text").on('input', function () {
        jQuery(this).next('.label-important:first').remove();
        return false;
    });
    
    jQuery("textarea").on('input', function () {
        jQuery(this).next('.label-important:first').remove();
        return false;
    });
	
	   
    jQuery("[type='submit']").off('click').on('click', function () {
        var f_element = jQuery(this);
        var bid = f_element.attr("id");
        var toRemove = 'btn_';
        var skid = bid.replace(toRemove, '');
        var form_data = jQuery("#forms_" + skid).serialize();
        
        jQuery("#form_" + skid).off('submit').on('submit', function (e) {
            e.preventDefault();
            jQuery("#btn_"+skid).hide(); 
           
		jQuery("#form_" + skid).append("<span id='spin'> <img src='https://www.ltcc.edu/_resources/js/ldp/loading.gif' height='50' width='50'></img> Submitting, Please Wait .. </span>"); 
        
        // disable submit while waiting for server response, to prevent multiple submissions
         jQuery("#btn_"+skid).hide();
          jQuery("#clr_"+skid).hide();
        
            jQuery("#form_" + skid + ".label-important").remove();
            
            if (jQuery("#form_" + skid + " #hp"+ skid ).val().length > 0) {
                
            } else {
                
                jQuery.ajax({
                    type: "POST",
                    cache: false,
                    url: "/_resources/php/ldp/modules/forms.php", 
                    data: jQuery(this).serialize(),
                    success: function (data) {
                        var resultObj = jQuery.parseJSON(data);
                        var errC = /[faultcode]+\s:/;
                        var faultCode = errC.exec(resultObj.message);
                        if (resultObj.active == false) {
                            if (! this.faultCode) {
                                jQuery("#status_" + skid).addClass("alert alert-error");
                                var dataSet = resultObj.message + "<br/>";
                                jQuery.each(resultObj.data, function (i, data) {
                                    var d = data.message;
                                    highlightID = "#id_" + data.name;
                                    errorHTML = '<span style="margin-left:8px;" class="label label-important" id="' + data.name + 'Error">' + data.message + '<br/></span>';
                                    if (jQuery('#' + data.name + 'Error').length == 0) {
                                        jQuery(highlightID).after(errorHTML);
                                    }
                                });
                                jQuery("#status_" + skid).html(dataSet);
                               
                                // re-enable submit button, so that user may fix errors and try again
 							    
 							      jQuery("#btn_"+skid).show();
                                  jQuery("#clr_"+skid).show();
                                   jQuery("#spin").remove(); 
                            } else {
                                var dataSet = resultObj.message + " " + resultObj.data[0].message;
                                jQuery("#status_" + skid).addClass("alert alert-error");
                                jQuery("#status_" + skid).html(dataSet);
                                jQuery(document).scrollTop(jQuery("#status_" + skid).offset().top);
                                
                            }
                        } else {
                            jQuery("#status_" + skid).removeClass("alert alert-error");
                            jQuery("#status_" + skid).addClass("alert alert-success");
                            
                            jQuery("#form_" + skid).remove();
                            jQuery("#status_" + skid).html(resultObj.message);
                            jQuery(document).scrollTop(jQuery("#status_" + skid).offset().top);
                        }
                    },
                    error: function (data) {
                    }
                });
                return false;
            }
        });
    });
});
