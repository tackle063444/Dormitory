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

 // เมื่อมีการเปลี่ยนค่าของหมายเลขห้อง
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

    $('#e_form').hide();
    $('#w_form').hide();
    
    $('.bill_list').on('change', function() {
      var selectedValue = $(this).val();
      console.log(selectedValue);
      var list_typeName = $(this).find('option:selected').text();
      if ((selectedValue.indexOf('1') > -1 && list_typeName == 'ค่าไฟ') ||
          (selectedValue.indexOf('2') > -1 && list_typeName == 'ค่าน้ำ')) {
        $('#e_form').show();
        $('#w_form').show();
      } else if (selectedValue == '1' && list_typeName == 'ค่าไฟ') {
        $('#e_form').show();
        $('#w_form').hide();
      } else if (selectedValue == '2' && list_typeName == 'ค่าน้ำ') {
        $('#w_form').show();
        $('#e_form').hide();
      } else {
        $('#e_form').hide();
        $('#w_form').hide();
      }
    });

    $(document).on('input', '#new_unit, #old_unit', function() {
      const oldUnit = parseFloat($('#old_unit').val()) || 0;
      const newUnit = parseFloat($('#new_unit').val()) || 0;
      const unitPrice = (newUnit - oldUnit).toFixed(2);
      $('#e_price').val(unitPrice);
    });
  
    //clone list form
    var formData = [];
    
    $('.add-list').click(function() {
      var $template = $('.bill-list').first().clone();
      var index = $('.bill-list').length;
      $template.find('select').each(function() {
        var name = $(this).attr('name').replace(/([0-9]+)/, index);
        var id = $(this).attr('id').replace(/([0-9]+)/, index);
        $(this).attr('name', name);
        $(this).attr('id', id);
        $(this).val('');
      });
      $('#bill-lists').append($template);
    });
    
    
    $(document).on('click', '.remove-list', function() {
      var $billLists = $('.bill-list');
      if ($billLists.length > 1) {
        $(this).closest('.bill-list').remove();
      }
    });  

    
    $('#ss_form').submit(function(event) {

      event.preventDefault();
      var formObj = $(this).serializeArray();
      formData.push(formObj);
      var data = JSON.stringify(formData);
      $.ajax({
        type: 'POST',
        url: '/save-data',
        data: { data: data },
        success: function(response) {
          alert('การบันทึกข้อมูลสำเร็จ');
        },
        error: function(response) {
       
          alert('การบันทึกข้อมูลไม่สำเร็จ');
          location.reload();
        }
      })
    });
    
 
    var formSelect = document.getElementById("bill_form");
    var selectedForm = formSelect.options[formSelect.selectedIndex].value;
    if (selectedForm) {
      document.getElementById("bill-form-heading").innerHTML = selectedForm;
    }

    //
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
