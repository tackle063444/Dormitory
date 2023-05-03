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

    // ซ่อนฟอร์มไว้เมื่อหน้าเว็บโหลดเสร็จ
    $('#e_form').hide();
    $('#w_form').hide();
    
    // เมื่อมีการเลือกค่าใน select
    $('#bill_list_id').on('change', function() {
      var selectedValue = $(this).val();
      if (selectedValue == '1') {
        $('#e_form').show();
      } else if (selectedValue == '2') {
        $('#water').show();
      } else {
        $('#e_form').hide();
        $('#w_form').hide();
      }
    });

    var formData = [];
    
    $('.add-list').click(function() {
      var formObj = $('#bill_form').serializeArray();
      formData.push(formObj);
      var template = $('.bill-list').first().clone();
      template.find('select').val('');
      $('#bill-lists').append(template);
    });
    
    
    $(document).on('click', '.remove-list', function() {
      var $billLists = $('.bill-list');
      if ($billLists.length > 1) {
        $(this).closest('.bill-list').remove();
      }
    });  


    $('form').submit(function(event) {
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
          // แสดงข้อความเตือนเมื่อมีข้อผิดพลาดในการส่งข้อมูล
          alert('การบันทึกข้อมูลไม่สำเร็จ');
        }
      })
    });
    
    // ตรวจสอบค่า default เมื่อหน้าเว็บโหลดเสร็จแล้ว
    var formSelect = document.getElementById("bill_form");
    var selectedForm = formSelect.options[formSelect.selectedIndex].value;
    if (selectedForm) {
      document.getElementById("bill-form-heading").innerHTML = selectedForm;
    }


  });
