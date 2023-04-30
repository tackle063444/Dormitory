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
    // ดักเหตุการณ์เมื่อผู้ใช้เลือกตัวเลือกในเลือกตัวเลือกฟอร์ม
    $('#bill-form-heading').css('display', 'none');
  
    // ดักเหตุการณ์เมื่อผู้ใช้เลือกตัวเลือกในเลือกตัวเลือกฟอร์ม
    $('#bill_form').on('change', function() {
      var selectedOption = $(this).val();
      var message = "";
      switch(selectedOption) {
        case "form1":
          message = "ใบแจ้งค่าบริการห้องพัก";
          $('#electricity-table').show(); //แสดงตารางค่าไฟที่ซ่อนอยู่
          break;
        case "form2":
          message = "ใบเสร็จรับเงินค่าเช่าห้องพัก";
          break;
        case "form3":
          message = "ใบเสร็จรับเงินค่ามัดจำห้องพัก";
          break;
        case "form4":
          message = "ใบแจ้งคืนค่าบริการห้องพัก";
          break;
        default:
          message = "";
          break;
      }
      $('#bill-form-heading').html(message).css('display', 'block');
    });

    
    $('.add-list').click(function() {
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
    
    // ตรวจสอบค่า default เมื่อหน้าเว็บโหลดเสร็จแล้ว
    var formSelect = document.getElementById("bill_form");
    var selectedForm = formSelect.options[formSelect.selectedIndex].value;
    if (selectedForm) {
      document.getElementById("bill-form-heading").innerHTML = selectedForm;
    }


  });
  