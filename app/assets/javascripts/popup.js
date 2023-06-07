var openBtn = document.getElementById('open-form-btn');
var popup = document.getElementById('form-popup');
var overlay = document.createElement('div');
overlay.classList.add('popup-overlay');

document.body.appendChild(overlay);

openBtn.onclick = function() {
  popup.classList.add('is-visible');
  overlay.classList.add('is-visible');
}

overlay.onclick = function() {
  popup.classList.remove('is-visible');
  overlay.classList.remove('is-visible');
}
