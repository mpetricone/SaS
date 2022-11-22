import * as Search from './search.js';

function hookSearch() {
	new Search.Searcher(
		'#distributer-search',
		'#product_distributer_products_attributes_0_distributer_id',
		'/distributers/search_by_name',
		(item) => {
			return item.name
		}).attach()
	new Search.Searcher(
		'#distributer-contact-search',
		'#distributer_contact_distributers_attributes_0_contact_id',
		'/contacts/search_by_name',
		(item) => {
			return item.lname+' '+item.fname
		}).attach()
	new Search.Searcher(
		'#client-search',
		'#client_client_contacts_attributes_0_contact_id',
		'/contacts/search_by_name',
		(item) => {
			return item.lname+' '+item.fname
		}).attach()
	new Search.Searcher(
		'#product-ticket-search',
		'#product_ticket_product_id',
		'/products/search_by_name',
		(item) => {
			return item.name
		}).attach()
	new Search.Searcher(
		'#employee-contact-search',
		'#employee_contact_id',
		'/contacts/search_by_name',
		(item) => {
			return item.lname+' '+item.fname
		}).attach()
};
$(document).on("turbo:load", hookSearch);
$(document).on("turbo:render", hookSearch);

