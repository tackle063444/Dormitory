# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/




$(document).on 'change', '#bill_form', (event) ->
  selected_form = $(this).val()

  # ส่ง AJAX request ไปยัง server
  $.ajax
    url: '/bill_form_partial'
    data: { form: selected_form }
    dataType: 'json'
    success: (data) ->
      # แทรก partial ของฟอร์มกลับมาในหน้าเดิม
      $('#bill-form-partial').html(data.html)

$(document).on 'click', '#submit-bill-form', (event) ->
  event.preventDefault()

  # ส่ง AJAX request ไปยัง server
  $.ajax
    url: '/submit_bill_form'
    data: $('#bill-form').serialize()
    dataType: 'json'
    success: (data) ->
      # แสดงผลลัพธ์จาก server
      if data.success
        alert(data.message)
      else
        alert(data.message)

  $(document).on 'ajax:success', '#bill-form', (event, data) ->
    # แสดง partial ของฟอร์มใหม่ที่ได้ร
