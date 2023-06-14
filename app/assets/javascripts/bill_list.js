
$(document).ready(function() {

  $(document).ready(function() {
    $('.re_value').each(function() {
      if ($(this).val() !== '' && $(this).val() !== '0') {
        $(this).val($(this).val());
      } else {
        $(this).val('');
      }
    });
  });
  

  $(document).on("change", ".re_value", function() {
    if ($(this).val() === '0') {
      $(this).val('');
    }
  });
  

  function checkSelectedForm() {
    let selectedOption = $('#form_select option:selected');
    let selectedForm = selectedOption.val();
    let selectedListType = selectedOption.text().trim();

    if (selectedForm === 'form4'&& selectedListType === 'ใบแจ้งคืนค่าบริการห้องพัก') {
      $('.two_r').show();
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
        tr.find('.old_unit, .new_unit, .e_price, .re_value').hide();
      } else {
        tr.find('.old_unit, .new_unit, .e_price, .re_value').show();
        tr.find('.amount').hide();
      }
    });
  }
  
  function calculate_form(selector) {
    let selectedOptionF = $('#form_select option:selected');
    let selectedForm = selectedOptionF.val();
    let tr = selector.closest('tr');
    let selectElement = tr.find('.bill_list');
    let selectedOption = selectElement.find(':selected');
    let unitPrice = parseFloat(selectedOption.data('unit-price'));
    let selectedListType = selectedOption.text().trim();
    let selectedListTypeF = selectedOptionF.text().trim();
    let twoRValue = tr.find('.two_rs').val();
  
    if (selectedForm === 'form4' && selectedListTypeF === 'ใบแจ้งคืนค่าบริการห้องพัก') {
      if (selectedOption.val() !== '1' && selectedListType !== 'ค่าไฟ') {
        let amount = parseFloat(tr.find('input.amount').val()) || 0;
        let headTotal = amount * unitPrice;
  
        if (twoRValue === 'form1') {
          tr.find('.head_total').val(headTotal);
          reT = headTotal;
        } else if (twoRValue === 'form2') {
          tr.find('.head_total').val('-' + headTotal);
          reC = headTotal;
        }
      } else {
        let oldUnit = parseFloat(tr.find('input.old_unit').val()) || 0;
        let newUnit = parseFloat(tr.find('input.new_unit').val()) || 0;
        let ePrice = newUnit - oldUnit;
        let headTotal = ePrice * unitPrice;
  
        if (tr.find('input.re_value').val() || tr.find('input.re_value').val()) {
          headTotal = (parseFloat(tr.find('input.re_value').val()) || 0) * ePrice;
        }else{
          headTotal = ePrice * unitPrice;
        }    
        
        if (twoRValue === 'form1') {
          tr.find('.e_price').val(ePrice);
          tr.find('.head_total').val(headTotal);
          reC = headTotal;
        } else if (twoRValue === 'form2') {
          tr.find('.e_price').val(ePrice);
          tr.find('.head_total').val('-' + headTotal);
          reT = headTotal;
        }
      }
  
      let bill_total = 0;
      $('.head_total').each(function() {
        let tr = $(this).closest('tr');
        let twoRValue = tr.find('.two_rs').val();
  
        if (twoRValue === 'form1') {
          let reT = parseFloat($(this).val()) || 0;
          bill_total += reT;
        } else if (twoRValue === 'form2') {
          let reC = parseFloat($(this).val()) || 0;
          bill_total += reC;
        }
      });
      $('.bill_total').val(bill_total);

    } else {
      if (selectedOption.val() !== '1' && selectedListType !== 'ค่าไฟ') {
        let amount = parseFloat(tr.find('input.amount').val()) || 0;
        let headTotal = amount * unitPrice;
  
        tr.find('.head_total').val(headTotal);
      } else {
        let oldUnit = parseFloat(tr.find('input.old_unit').val()) || 0;
        let newUnit = parseFloat(tr.find('input.new_unit').val()) || 0;
        let ePrice = newUnit - oldUnit;
        let headTotal = ePrice * unitPrice;
  
        if (tr.find('input.re_value').val() || tr.find('input.re_value').val()) {
          headTotal = (parseFloat(tr.find('input.re_value').val()) || 0) * ePrice;
        }else{
          headTotal = ePrice * unitPrice;
        }     
  
        tr.find('.e_price').val(ePrice);
        tr.find('.head_total').val(headTotal);
      }
  
      let bill_total = 0;
      $('.head_total').each(function() {
        let val = parseFloat($(this).val()) || 0;
        bill_total += val;
      });
      $('.bill_total').val(bill_total);
    }
  }
  
  
  toggleFields();


  $('body').on('change','.bill_list', function() {
    toggleFields();
    calculate_form($(this));
    updateUnitPrice($(this));
  })

  $('body').on('change','.two_rs', function() {
    toggleFields();
    calculate_form($(this));
  })

  $(document).on("change keyup", ".old_unit, .new_unit, .re_value, .amount, .head_total, .two_rs", function() {
    calculate_form($(this));
  });


});
