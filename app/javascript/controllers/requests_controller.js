import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
    connect() {
        if (!$.fn.DataTable.isDataTable('#requests-table')) {
            $('#requests-table').DataTable({
                paging: true,
                searching: true,
                ordering: true,
                info: true,
                columnDefs: [
                    { orderable: false, targets: "no-sort" }, // Disable sorting for columns with the "no-sort" class
                    { type: "date", targets: 3 } // Ensure the "Requested At" column (index 3) is sorted by date
                ],
                order: [[3, "asc"]]
            });
        }
    }
}
