$(function() {
	//***Toggle Editor Buttons***//
	$('div[class^=testing-comments]').toggle(); //hide all editor buttons
	
	
	//***Variables***//
    var host = $(location).attr('host');
	//API Calls
	var callVars = 'http://' + host + '/directories/settings?path=/';
	var callSnippets = 'http://' + host + '/snippets/list?';
	var callAssets = 'http://' + host + '/assets/list?';
	var callTemplates = 'http://' + host + '/templates/list?';
	var callTCFs = 'http://' + host + '/templates/view?';
	var callTMPLs = 'http://' + host + '/files/properties?';
	//common parameters for API calls:
	var account = $('#account-name').text(); 
	var site = $('#site-name').text();
	var path = '/'; //'/_resources/ou/templates/'
	
	var exclusionList = $('#exclusions').text().replace(/\s+/g, '').split(",");
	var exclusions = ['testing'];
	exclusions = exclusions.concat(exclusionList);
	

	//***Functions***//
	function pathFinder(url) {
		var term = "path=";
		url = url.substring(url.indexOf(term)+term.length).split("/");
		url.pop();
		url = url.join("/") + "/";
		return url;
	}
	
	function dupRemover(array) {
		var uniqueElements = [];
		$.each(array, function(i, el){
			if ($.inArray(el, uniqueElements) === -1) {
				uniqueElements.push(el);
			};
		})
		return uniqueElements;
	}

	
	
	//***Directory Vars***//
	$.get(callVars, {account: account, site: site}, function(data) {
		var variables = data.variables;
		$.each(Object.keys(variables), function(i, key){
			$('#site-vars').append('<tr><td>' + key + '</td><td>' + variables[key] + '</td></tr>');	
		})
	})


	
	//***Snippets***//
	$.get(callSnippets, {account: account, site: site}, function(data) {
		$.each(data[0], function(i, category){
			var key = Object.keys(category)[0];
			var id = key.split(' ').join('-'); //used for ID attr
			$('#snippet-container').append('<h4>' + key + '<a class="btn btn-link btn-sm" type="button" data-toggle="collapse" href="#snippets-' + i + '">[toggle]</a></h4>');
			$('#snippet-container').append('<div class="collapse" id="snippets-' + i + '"><table class="table table-striped"><thead><tr><th>Name</th><th>File Name</th><th>Description</th></tr></thead><tbody id="snip-' + id + '"></tbody></table></div>');
			$.each(category[key], function(i, snippet){
				$('#snip-' + id).append('<tr><td>' + snippet.snippet + '</td><td>' + snippet.path + '</td><td>' + snippet.description + '</td></tr>');
			})
		})
	});


	
	//***Assets***//
	$.get(callAssets, {account: account, site: site}, function(data) {
		$.each(data.entries, function(i, asset) {
			$('#site-assets').append('<tr><td>' + asset.name + '</td><td>' + asset.type_name + '</td><td>' + asset.permissions.dm_tag + '</td><td>' + asset.tags.slice(2).join(', ') +
				'</td><td>' + asset.site + '</td><td>' + asset.site_locked + '</td><td>' + asset.permissions.has_limited_access_settings + '</td><td>' + asset.description + '</td></tr>');
		});
	});	


	
	//***Templates***//
	$.when( 
		$.get(callTemplates, {account: account, site: site}) 
	).then(function(data) {
		//get template names and build HTML structure needed for tcf/tmpl calls
		$.each(data.templates, function(i, template){
			var name = template.name.replace('.tcf','');
			if ($.inArray(name,exclusions) == -1) {
				$('#templates-accordion').append('<div id="template-' + name + '" class="panel panel-default"></div>');
				$('#template-' + name).append('<div class="panel-heading" id="template-heading-' + i + '"><h4 class="panel-title"><a role="button" data-toggle="collapse" data-parent="#templates-accordion" href="#collapse-template-' + i + '">' + template.alt + '</a></h4></div>' + '<div id="collapse-template-' + i + '" class="panel-collapse collapse"><div class="panel-body"><div class="col-md-2"><img src="'+ template.default_img_url + '" /></div><div class="col-md-10"><table id="tcf-' + name + '" class="table-striped table"><caption>data from ' + name + '.tcf</caption><thead><tr><th>Page Option</th><th>Alt</th><th>Value</th></tr></thead><tbody></tbody></table></div><div class="row" id="template-input-'+ i +'"></div></div></div>');
				$('#template-input-' + i).append($('.testing-comments-' + i).toggle());
			}
		})
		return data;
	}).then(function(data) {
		var templates = data.templates;
		$.each(templates, function(i, template) {
			var name = template.name.replace('.tcf','');
			if ($.inArray(name,exclusions) == -1){
				var url = pathFinder(template.default_img_url);
				$.when( 
					$.get(callTCFs, {account: account, site: site, path: path, template: name + '.tcf'}) 
				).then(function(data) {
					//populate template panels with tcf info
					var fields = data.fields;
					var tmpls = [];
					$.each(fields, function(i, field){
						var options = [];
						if (field.options) {
							$.each(field.options, function(i, option) {
								if (option.selected === 'true'){
									options.push('<strong>' + option.text + '</strong>');
								} else {
									options.push(option.text);	
								}
							});
							var options = options.join(', ');
						}
						if (field.template){
							tmpls.push(field.template);
						}
						$('#tcf-' + name + ' > tbody').append('<tr><td>' + field.prompt + '</td><td>' + field.alt + '</td><td>' + options + '</td></tr>');
					})
					return dupRemover(tmpls);
				}).then( function(tmpls) {
					$.each(tmpls, function(i,tmpl){
						var id = name + '-' + tmpl.replace('.tmpl','')
						$('#tcf-' + name).after('<table id="tmpl-' + id + '" class="table-striped table"><caption>data from ' + tmpl + '</caption><thead><tr><th>Parameter</th><th>Alt</th><th>Type</th></tr></thead><tbody></tbody></table>');
						$.get(callTMPLs, {account: account, site: site, path: url + tmpl}, function(data) { //populate template panels with tmpl info
							if (data.parameters.length > 0) {
								$.each(data.parameters, function(j, param) {
									$('#tmpl-' + id + ' > tbody').append('<tr><td>' + param.name + '</td><td>' + param.alt + '</td><td>' + param.type + '</td></tr>');	
								})
							} else {
								$('#tmpl-' + id + ' > tbody').append('<tr><td>n/a</td><td>n/a</td><td>n/a</td></tr>');
							}
						}).fail(function(res) {
							$('#tmpl-' + id + ' > tbody').append('<tr><td>n/a</td><td>n/a</td><td>n/a</td></tr>');
						})							
					})

				})
			}
		})
	})	
})
