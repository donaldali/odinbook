jQuery ->
  # Validate Edit profile form for content type and size
  # Size validation uses a custom validator
  if $('#profile_picture').length
    $.validator.addMethod 'filesize', ((val, ele, param) ->
      this.optional(ele) or ele.files[0].size <= param * 1024),
      "Image filesize cannot exceed {0} kilobytes"

    $('#profile_picture').closest('form').validate
      errorElement: 'span'

      rules:
        'profile[picture]':
          accept: /^image\/(jpe?g|png|gif)$/
          filesize: 500

      messages:
        'profile[picture]':
          accept: 'Image type must be jpeg, jpg, gif, or png'


  # Validate Signup form
  if $('body.sessions').length or $('body.registrations').length
    $('#signup-form').validate
      errorElement: 'span'

      rules:
        'user[first_name]': 'required'
        'user[last_name]':  'required'
        'user[email]':
          required: true
          email: true
          remote: '/unused_email'
        'user[password]':
          required: true
          minlength: 6
        'user[password_confirmation]':
          required: true
          equalTo: '#user_signup_password'
        'user[gender]': 'required'

      messages:
        'user[first_name]': "What's your first name?"
        'user[last_name]':  "What's your last name?"
        'user[email]':
          required: 'Please enter your email address'
          email: 'Please enter a valid email address'
          remote: 'Your email is already used. Choose another'
        'user[password]':
          required: 'Please enter a password'
          minlength: 'Password must be at least {0} characters'
        'user[password_confirmation]':
          required: 'Please re-enter your password'
          equalTo: 'This must match your password'
        'user[gender]': 'Please select a gender'
