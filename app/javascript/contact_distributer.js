import * as Search from "./search.js";

function cdSearchHook() {
    new Search.Searcher(
        '#distributer-contact-search',
        '#contact_distributer_contact_id',
        '/contacts/search_by_name',
        (item) => {
            return item.lname + ', ' + item.fname;
        }).attach();
}
$(document).on("turbo:load", cdSearchHook)
$(document).on("turbo:render", cdSearchHook)