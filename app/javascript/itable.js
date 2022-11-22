$(document).on('turbo:load', () => {
  $('body').on('click', '.clickable-row', (event) => {
    console.log(event)
    window.open(event.currentTarget.attributes['data-href'].value)
  })
})
