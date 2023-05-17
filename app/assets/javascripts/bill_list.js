$(document).ready(function() {
  // ซ่อนหรือแสดง old_unit และ new_unit ตามเงื่อนไข

  $(document).on("change", "#form_select", function() {
    checkSelectedForm();
  });
  
  $(document).on("change", ".two_rs", function() {
    checkSelectedForm();
  });

  function checkSelectedForm() {
    const selectedOption = $('#form_select option:selected');
    const selectedForm = selectedOption.val();
    const selectedListType = selectedOption.text().trim();
  

    if (selectedForm === 'form4'&& selectedListType === 'ใบแจ้งคืนค่าบริการห้องพัก') {
      $('.two_r').show();
      const twoRValue = $('.two_rs').val();
      console.log(twoRValue);

      //คืน
      if (twoRValue === 'form2') {
        let returnTotal = 0;
        
        //หัก
      } else if (twoRValue === 'form1') {
        let reciveTotal = 0;
        
      }
    } else {
      $('.two_r').hide();
    }
  }

  function toggleFields() {
    $('.bill_list').each(function() {
      var tr = $(this).closest('tr');
      var selectedOption = $(this).find('option:selected');
      var selectedListType = selectedOption.text().trim();
      
      if (selectedOption.val() !== '1' && selectedListType !== 'ค่าไฟ') {
        tr.find('.old_unit, .new_unit, .e_price').hide();
      } else {
        tr.find('.old_unit, .new_unit, .e_price').show();
        tr.find('.amount').hide();
      }
    });
  }

  function calculate_form(selector) {
    const tr = selector.closest('tr');
    const selectElement = tr.find('.bill_list');
    const selectedOption = selectElement.find(':selected');
    const unitPrice = parseFloat(selectedOption.data('unit-price'));
    const selectedListType = selectedOption.text().trim();
  
    if (selectedOption.val() !== '1' && selectedListType !== 'ค่าไฟ') {
      const amount = parseFloat(tr.find('input.amount').val()) || 0;
      const headTotal = amount * unitPrice;
      tr.find('.head_total').val(headTotal);
    } else {
      const oldUnit = parseFloat(tr.find('input.old_unit').val()) || 0;
      const newUnit = parseFloat(tr.find('input.new_unit').val()) || 0;
      const ePrice = newUnit - oldUnit;
      const headTotal = ePrice * unitPrice;
      tr.find('.e_price').val(ePrice);
      tr.find('.head_total').val(headTotal);
    }
  }

  function calculateBillTotal() {
    let bill_total = 0;
    $('.head_total').each(function() {
      const val = parseFloat($(this).val()) || 0;
      bill_total += val;
    });
    $('.bill_total').val(bill_total);
  }

  
  toggleFields();

  $(document).on("change", ".bill_list", function() {
    toggleFields();
    calculate_form(); 
    });
    
  $(document).on("change keyup", ".old_unit, .new_unit, .amount, .head_total", function() {
    calculate_form($(this));
    calculateBillTotal($(this));
  });
  

$('body').on('change', '.bill_list', function() {
  var selectedOptionValue = $(this).val();

  if ($('.bill_list').filter(function() { return $(this).val() == selectedOptionValue; }).length > 1) {
    alert('ไม่สามารถเลือก bill_list_id ที่ซ้ำกันได้');
    $(this).val(''); 
  }
});

// เมื่อกดปุ่มเพิ่มฟอร์ม
$('body').on('click', '.add_nested_fields', function() {
  
  var selectedOptionValue = $(this).closest('.nested-fields').find('.bill_list').val(); // ค่าของ option ที่ถูกเลือกในฟอร์มก่อนหน้านี้

  // ถ้ามีฟอร์มที่มี bill_list_id เดียวกับ option ที่ถูกเลือกในฟอร์มก่อนหน้านี้
  if ($('.bill_list').filter(function() { return $(this).val() == selectedOptionValue; }).length > 0) {
    alert('ไม่สามารถเพิ่มฟอร์มที่มี bill_list_id เดียวกับฟอร์มก่อนหน้าได้');
    return false; // ไม่ให้เพิ่มฟอร์ม
  }
});



});
