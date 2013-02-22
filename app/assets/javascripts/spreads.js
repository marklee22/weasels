$(document).ready(function() {
	$('select').change(function() {
		$('#spread_form').submit();
	});
});