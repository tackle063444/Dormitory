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
//= require turbolinks
//= require_tree .
//= require jquery 
//= require jquery_ujs 
//= require nested_form_fields
//= require jquery3
//= require jquery_ujs
//= require cocoon

$(document).ready(function() {
  

 // show user rent in room
 $('#room-select').on('change', function() {
  var room_id = $(this).val(); // ดึงค่าของหมายเลขห้องที่ถูกเลือก
  // ส่ง request เพื่อดึงข้อมูลผู้ใช้งาน
  $.ajax({
    url: '/get_rent_user_info',
    data: { room_id: room_id },
    success: function(response) {
      // สร้าง HTML สำหรับแสดงผลข้อมูลผู้ใช้งาน
      var html = '<ul>';
      $.each(response, function(index, user) {
        html += '<li>' + ' -> ' + user.user_fname + ' ' + user.user_lname + '</li>';
      });
      html += '</ul>';
      // แสดงผลข้อมูลผู้ใช้งานใน tag HTML ที่มี id เท่ากับ "rent-user-info"
      $('#rent-user-info').html(html);
    }
  });
  });

    var formSelect = document.getElementById("bill_form");
    var selectedForm = formSelect.options[formSelect.selectedIndex].value;
    if (selectedForm) {
      document.getElementById("bill-form-heading").innerHTML = selectedForm;
    }

    //check user rent?
    $('#c_user').on('change', function() {
      var selected_user_id = $(this).val();
      var selected_room_id = $('#rent_room_id').val();
    
      $.ajax({
        url: '/checkRent',
        data: {
          user_id: selected_user_id,
          room_id: selected_room_id
        },
        success: function(response) {
          if (response == 'rented' || selected_user_id == '<%= @rent.user_id %>') {
            $(`#c_user option[value="${selected_user_id}"]`).hide();
          } else {
            // ถ้ายังไม่เช่าให้แสดงผลต่อไป
          }
        },
        error: function() {
          console.log('An error occurred while checking for rent history.');
        }
      });
    });

    
    

  });
