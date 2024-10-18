$(function() {
	$('#btnSignUp').click(function() {
	  // Validate email format
	  const email = $('#inputEmail').val();
	  const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
	  
	  if (!emailPattern.test(email)) {
		showMessage('Invalid email format', 'alert-danger');
		return;
	  }
	  
	  // If email is valid, send AJAX request
	  $.ajax({
		url: '/signUp',
		data: $('form').serialize(),
		type: 'POST',
		success: function(response) {
		  showMessage('Sign up successful!', 'alert-success');
		  console.log(response);
		},
		error: function(error) {
		  showMessage('Sign up failed. Please try again.', 'alert-danger');
		  console.log(error);
		}
	  });
	});
  
	// Helper function to show messages
	function showMessage(message, alertClass) {
	  $('#message').text(message)
				   .removeClass('alert-success alert-danger')
				   .addClass(alertClass)
				   .show();
	}
  });
  