$(document).on("turbo:load", () => {
  $.ajax("/tickets/index_latest.js?limit=5");
  $("#collapse-ou").on("show.bs.collapse", () => {
    $("#ou-collapse-toggle").html('<i class="fa fa-window-minimize"></i>');
  });
  $("#collapse-ou").on("hidden.bs.collapse", () => {
    $("#ou-collapse-toggle").html('<i class="fa fa-window-maximize"></i>');
  });
});
