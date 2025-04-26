// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
//= require jquery3
//= require popper
//= require bootstrap
// import "@hotwired/turbo-rails"
import "assignments"
import "controllers"
import "rails-ujs-override"

// Import jQuery and DataTables
import "jquery";
import "datatables.net";

// Initialize DataTables
document.addEventListener("DOMContentLoaded", () => {
  $('#requests-table').DataTable({
    paging: true,
    searching: true,
    ordering: true,
    info: true,
    columnDefs: [
      { orderable: false, targets: "no-sort" } // Disable sorting for columns with the "no-sort" class
    ],
    order: [[3, "asc"]] // Default sort by the "Requested At" column in ascending order
  });
});