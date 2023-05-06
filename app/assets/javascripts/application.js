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

    //calculate function
    $(document).on('input', '#new_unit, #old_unit', function() {
      const oldUnit = parseFloat($('#old_unit').val()) || 0;
      const newUnit = parseFloat($('#new_unit').val()) || 0;
      const unitPrice = (newUnit - oldUnit).toFixed(2);
      $('#e_price').val(unitPrice);
    });
  
    //clone list form
    document.addEventListener("DOMContentLoaded", function() {
      const addListBtn = document.querySelector(".add-list");
      const billLists = document.querySelector("#bill-lists");
      const submitBtn = document.querySelector("#ss_form");
  
      let billListCounter = 1;
      const billListArray = [];
  
      addListBtn.addEventListener("click", function() {
        const newBillList = document.createElement("div");
        newBillList.classList.add("bill-list");
        newBillList.innerHTML = `
          <select name="bill[bill_list_ids][]" class="bill_list">
            <option value="">เลือกรายการ</option>
            <% BillList.all.each do |list| %>
              <option value="<%= list.id %>"><%= list.list_typeName %></option>
            <% end %>
          </select>
          <button type="button" class="remove-list">ลบ</button>
        `;
        billLists.appendChild(newBillList);
  
        billListArray.push(newBillList.querySelector(".bill_list").value);
        billListCounter++;
      });
  
      billLists.addEventListener("click", function(e) {
        if (e.target.classList.contains("remove-list")) {
          e.target.closest(".bill-list").remove();
  
          const index = billListArray.indexOf(e.target.closest(".bill-list").querySelector(".bill_list").value);
          if (index > -1) {
            billListArray.splice(index, 1);
          }
          billListCounter--;
        }
      });
  
      submitBtn.addEventListener("click", function() {
        const hiddenInput = document.createElement("input");
        hiddenInput.type = "hidden";
        hiddenInput.name = "bill[bill_list_ids]";
        hiddenInput.value = billListArray.join(",");
        this.form.appendChild(hiddenInput);
      });
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
