import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
    connect() {
        if (!$.fn.DataTable.isDataTable('#enrollments-table')) {
            $('#enrollments-table').DataTable({
                paging: true,
                searching: true,
                ordering: true,
                info: true,
                columnDefs: [
                    { orderable: false, targets: [] } // Add column indices here if you want to disable sorting
                ],
                order: [[0, "asc"]] // Default sort by the first column (Name) in ascending order
            });
        }
    }
}