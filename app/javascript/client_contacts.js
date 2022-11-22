import * as Search from "./search.js";

function ccSearchHook() {
  new Search.Searcher(
    '#client-contact-search',
    '#client_contact_contact_id',
    '/contacts/search_by_name',
    (item) => {
      return item.lname + ', ' + item.fname;
    }).attach();
}
$(document).on("turbo:load", ccSearchHook)
$(document).on("turbo:render", ccSearchHook)