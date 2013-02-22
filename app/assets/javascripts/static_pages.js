$(document).ready(function() {
	$('dt').click(function() {
		$(this).toggleClass("expanded").next().toggleClass("expanded").animate({opacity: "toggle", height: "toggle"}, 200);
		$(this).trigger($(this).is(".expanded")?"expanded":"collapsed");
	});
});
// 
// var w=w||{};
// w.qaToggle=function(a){
// 	a.toggleClass("expanded").next().toggleClass("expanded").animate({
// 		opacity:"toggle",height:"toggle"},200);
// 		a.trigger(a.is(".expanded")?"expanded":"collapsed")
// 		};
// 		w.qaExpander=function(a,c){
// 			$(".qa-list dt").click(function(){
// 				var b=$(this);
// 				w.qaToggle(b);
// 				w.trackEvent(a,c,$.trim(b.text()))})};
// 				w.qaExpandOnLoad=function(){
// 					if(location.hash){
// 						var a=$(location.hash);
// 						a.is("dt")&&(a.trigger("click"),w.trackEvent("FAQ","open-question-by-hash",location.hash))}};