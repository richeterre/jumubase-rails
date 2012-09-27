function remove_fields(link) {
	$(link).prev("input[type=hidden]").val("1");
	$(link).closest(".field-group").slideUp(function () {
		renumber();
	});
}

function add_fields(link, association, content) {
	var new_id = new Date().getTime();
	var regexp = new RegExp("new_" + association, "g")
	$(content.replace(regexp, new_id)).appendTo($(link).parent()).hide().slideDown(function () {
		renumber();
	});
}

function renumber() {
	// Renumber appearances
	$(".appearance:visible").each(function (index) {
		$(".number", $(this)).text(index + 1);
	});
	
	// Renumber pieces
	$(".piece:visible").each(function (index) {
		$(".number", $(this)).text(index + 1);
	});
}
