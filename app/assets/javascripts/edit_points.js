$(document).ready(function() {
  // Edit button
  $('.edit-points').live('click', function() {
      var $pointSpan = $(this).closest('tr').find('span.points');
      var $pointInput = $('<input type="text" maxlength="2" data-path="'
                          + $pointSpan.attr('data-path') + '" class="points" '
                          + 'style="width: 20px;" value="' + $.trim($pointSpan.html()) + '" />');
      // Hide current points, add entry field after them
			$pointSpan.after($pointInput).hide();
			// Show save/cancel buttons
      $(this).closest('tr').find('.save-points, .discard-points').show();
			// Hide edit button
      $(this).hide();
			// Move focus for quicker user input
      $pointInput.focus();
  });
  
  // Save button
  $('.save-points').live('click', function() {
    var $pointInput = $(this).closest('tr').find('input.points');
    
    $.ajax({
    	type: 'put', 
      data: 'appearance[points]=' + $pointInput.val(),
      dataType: 'script',
      context: $(this).closest('tr'),
      error: function(request) {
        alert("Die Punktzahl ist ungültig, oder es liegt ein Serverproblem vor.");
        $(this).find('input.points').addClass('invalid');
      },
      url: $pointInput.attr('data-path'),
		});
  });
  
  // Cancel button
  $('.discard-points').live('click', function() {
			// Remove point input field
      var $pointInput = $(this).closest('tr').find('input.points');
			$pointInput.remove();
			// Hide save/cancel buttons
      $(this).closest('tr').find('.save-points, .discard-points').hide();
			// Show current points again
      $(this).closest('tr').find('.edit-points, span.points').show();
  });
});