import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
    connect() {
        if (!$.fn.DataTable.isDataTable('#requests-table')) {
            const table = $('#requests-table').DataTable({
                paging: true,
                searching: true,
                ordering: true,
                info: true,
                columnDefs: [
                    { orderable: false, targets: "no-sort" }, // Disable sorting for columns with the "no-sort" class
                    { type: "date", targets: [3, 4, 5] } // Ensure "Requested At", "Original Due Date", and "Requested Due Date" are sorted by date
                ],
                order: [[3, "asc"]] // Default sort by the "Requested At" column in ascending order
            });

            // Pre-fill the search bar if a search query is provided
            const searchQuery = document.getElementById('requests-table').dataset.searchQuery;
            if (searchQuery) {
                table.search(searchQuery).draw();
            }
        }
    }
}
