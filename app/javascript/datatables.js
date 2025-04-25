// Initialize DataTables on tables with the class "datatable"
document.addEventListener("DOMContentLoaded", () => {
  const tables = document.querySelectorAll(".datatable");

  tables.forEach((table) => {
    $(table).DataTable({
      paging: true,         // Enable pagination
      searching: true,      // Enable search functionality
      ordering: true,       // Enable column sorting
      info: true,           // Show table information
      columnDefs: [
        { orderable: false, targets: "no-sort" } // Disable sorting for columns with the "no-sort" class
      ],
      order: [[0, "asc"]]   // Default sort by the first column in ascending order
    });
  });
});