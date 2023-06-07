# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
###
$ ->
  $('#add-user-btn').click (e) ->
    e.preventDefault()
    lastSelect = $('select[name="rent[user_id][]"]').last()
    newSelect = lastSelect.clone()
    newSelect.find('option').prop 'selected', false
    newSelect.insertAfter lastSelect



addNewUser = ->
  lastSelect = $('select[name="rent[user_id][]"]').last()
  newSelect = lastSelect.clone()
  newSelect.find('option').prop 'selected', false
  newSelect.insertAfter lastSelect

$ ->
  $('#add-user-btn').click (e) ->
    e.preventDefault()
    addNewUser()
###
