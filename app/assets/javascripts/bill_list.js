$(document).ready(function() {
  // ซ่อนหรือแสดง old_unit และ new_unit ตามเงื่อนไข
  function toggleFields() {
    $('.bill_list').each(function() {
      var tr = $(this).closest('tr');
      var selectedOption = $(this).find('option:selected');
      var selectedListType = selectedOption.text().trim();
      
      if (selectedOption.val() !== '1' && selectedListType !== 'ค่าไฟ') {
        tr.find('.old_unit, .new_unit').hide();
      } else {
        tr.find('.old_unit, .new_unit').show();
      }
    });
  }

  function calculate_form(selector) {

    const selectElement = $('.bill_list');
    const selectedOption = selectElement.find(':selected');
    const unitPrice = parseFloat(selectedOption.data('unit-price'));
    var tr = selector.closest('tr');
    var selectedListType = selectedOption.text().trim();
    var oldUnit = parseFloat(tr.find('input.old_unit').val()) || 0;
    var newUnit = parseFloat(tr.find('input.new_unit').val()) || 0;
    var amount = parseFloat(tr.find('input.amount').val()) || 0;
  
    if (selectedOption.val() !== '1' && selectedListType !== 'ค่าไฟ') {
      var headTotal = amount * unitPrice;
      tr.find('.head_total').val(headTotal);
    } else {
      if (selectedOption.val() === '1') {
        var amount = newUnit - oldUnit;
      }
      var headTotal = amount * unitPrice;
      tr.find('.amount').val(amount);
      tr.find('.head_total').val(headTotal);
    }
  }  
  
  
  toggleFields();

  $(document).on("change", ".bill_list", function() {
    toggleFields();
    calculate_form(); 
    });
    
  $(document).on("change keyup", ".old_unit, .new_unit, .amount, .head_total", function() {
    calculate_form($(this));
  });
  

});
