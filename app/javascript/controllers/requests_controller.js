import { Controller } from "@hotwired/stimulus";
import DataTable from "datatables.net-bs5";
import "datatables.net-responsive";
import "datatables.net-responsive-bs5";

export default class extends Controller {
    connect() {
        if (!DataTable.isDataTable('#requests-table')) {
            const searchQuery = this.element.dataset.searchQuery;
        
            this.table = new DataTable('#requests-table', {
                paging: true,
                searching: true,
                ordering: true,
                info: true,
                // responsive: true,
                columnDefs: [
                    { orderable: false, targets: 'no-sort' }, // Disable sorting for columns with the "no-sort" class
                    { type: "date", targets: [3, 4, 5] } // Ensure "Requested At", "Original Due Date", and "Requested Due Date" are sorted by date
                ],
                order: [[3, "asc"]] // Default sort by the "Requested At" column in ascending order
            });
        
            if (searchQuery) {
                this.table.search(searchQuery).draw();
            }
        }
    }
}
