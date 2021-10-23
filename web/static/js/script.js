$(document).ready(function() {
	function check_seasons() {
	$('.season').each(function() {
		var id = $(this).attr('id').split('_');
		id=id[1];
		var not=false;
		$("#episodes_"+id).find('input:checkbox').each(function() {if(!$(this).is(':checked')){not=true;}});

		$('#season_'+id).attr('checked', !not);
	});
	}

	check_seasons();

	$('.season_w_checkbox').click(function() {
		var id = $(this).attr('id').split('_');
		id=id[1];

		if($(this).is(':checked')) {

			$("#episodes_"+id).find('input:checkbox').each(function() {
				if(!$(this).is(':checked')) {


					var id = $(this).attr('id').split('_');
		var ep_id=id[1];

		$.get('/episodes/episode/'+ep_id+'/watch_switch', function(data) {

		});
				}
				$(this).attr('checked', true);
				});

		}else{

			$("#episodes_"+id).find('input:checkbox').each(function() {
				if($(this).is(':checked')) {

					var id = $(this).attr('id').split('_');
		var ep_id=id[1];

		$.get('/episodes/episode/'+ep_id+'/watch_switch', function(data) {

		});
				}
				$(this).attr('checked', false);

			});
		}
	});


	$('.index_episodes').click(function() {
		var arr = ['my_shows','cancelled_shows','ignored_shows'];
		for(var item in arr) {
			if($(this).attr('id')== arr[item]) {
				$('#'+arr[item]).addClass('ui-btn-active');
				$('#'+arr[item]+'_x').show();
			}else{
				$('#'+arr[item]).removeClass('ui-btn-active');
				$('#'+arr[item]+'_x').hide();
			}
		}
	});

	$('.index_list').click(function() {
		var arr = ['last_episodes','coming_episodes','countdown_episodes'];
		for(var item in arr) {
			if($(this).attr('id')== arr[item]) {
				$('#'+arr[item]).addClass('ui-btn-active');
				$('#'+arr[item]+'_x').show();
			}else{
				$('#'+arr[item]).removeClass('ui-btn-active');
				$('#'+arr[item]+'_x').hide();
			}
		}
	});



	$('#search_form').focus(function() {
		$('#search_form').val('');
	})

	$('#search_form').blur(function() {
		if($('#search_form').val()==""){
		$('#search_form').val('search');
		$('#search_form').css('font-style','italic');
			$('#search_form').css('color','#666');
		}
	});

	//Search
	$(function() {
	    var input = $('#search_q');

	    input.focus(function() {
	    	if($(this).val() == $(this).attr('data-title')) {
	         	$(this).val('');
	    	}
	    }).blur(function() {
	         var el = $(this);
	         if(el.val() == '')
	             el.val(el.attr('data-title'));
	    });
	 });

	var search_form_loading = false;
	var search_form_loading_q = '';

	function search_q_keyup() {
		if(search_form_loading == true) return;
		var search_form_loading_q = $('#search_q').val();

		if(search_form_loading_q == '') return;

	    search_form_loading = true;



	    var url = '/search?q='+escape(search_form_loading_q);



	        $.ajax({
	            url: url,
	            cache: false
	        }).done(function( html ) {
	            search_form_loading=false;
	            $("#content_ajax").html(html);

	            window.history.pushState(null, null, url);

	            if(search_form_loading_q != $('#search_q').val()) {
	            	search_q_keyup();
	            }
	        });
	}

	$('#search_q').keyup(function() {
		search_q_keyup();
	});
});
