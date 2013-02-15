function sum_picks() {
	var sum = 0;
	$(".pick-table-score").each(function() {
		var value = $(this).text();
		if(!isNaN(value) && value.length != 0) {
			// console.log(value);
			sum += parseFloat(value);
			// console.log(sum);
		}
	});
	$('#pick-total').text('Total: '+ sum);
};

$(document).ready(function() {
	$(sum_picks);
});