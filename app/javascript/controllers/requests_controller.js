import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
    connect() {
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
    }
}