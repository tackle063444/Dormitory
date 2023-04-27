// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
// require rails-ujs ถูกโหลดแล้ว ไม่ต้องโหลดซ้ำ
//= require turbolinks
//= require_tree .
//= require jquery 
//= require jquery_ujs 

$(document).ready(function() {
  console.log(522252525)
  $(document).on('change', '#bill_form', function(event) {
    var selected_form = $(this).val();

    $.ajax({
      url: '/bill_form_partial',
      data: { form: selected_form },
      dataType: 'json',
      success: function(data) {
        $('#bill-form-partial').html(data.html);
      }
    });
  });

  $(document).on('click', '#submit-bill-form', function(event) {
    event.preventDefault();

    $.ajax({
      url: '/submit_bill_form',
      data: $('#bill-form').serialize(),
      dataType: 'json',
      success: function(data) {
        if (data.success) {
          alert(data.message);
        } else {
          alert(data.message);
        }
      }
    });
  });

  $(document).on('ajax:success', '#bill-form', function(event, data) {
    $('#bill-form-partial').html(data.html);
  });


})