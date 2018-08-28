function fadeNotification() {
  var notif = document.querySelector('.global-notification');
  fadeOut(notif);
}

function fadeOut(el){
  if(el) {
    el.style.opacity = 1;

    (function fade() {
      if ((el.style.opacity -= .1) < 0) {
        el.style.display = "none";
      } else {
        requestAnimationFrame(fade);
      }
    })();
  }
}

setTimeout(fadeNotification, 4000);

