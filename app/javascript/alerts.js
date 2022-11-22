var fadeOutItem = function(item, timer) {
  $(item).delay(timer).fadeOut(1000)
}

$(document).on("turbo:load", ()=> {
  fadeOutItem('.notice-alert', 2500)
  fadeOutItem('.alert-alert', 5000)
})
