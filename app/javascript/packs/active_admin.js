// Load Active Admin's styles into Webpacker,
// see `active_admin.scss` for customization.

import 'bootstrap';
import '../stylesheets/application';

import "../stylesheets/active_admin.scss";

import "@activeadmin/activeadmin";

import "./active_admin/active_admin_flat_skin";

$(document).ready(function() {
  let datepicker = $('input.datepicker');
  datepicker.each(function(index,item) {
    item.setAttribute('autocomplete','off');
  })
})
