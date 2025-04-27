import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
    connect() {
        if (!$.fn.DataTable.isDataTable('#enrollments-table')) {
            // Define a custom sorting function for the Role column
            $.fn.dataTable.ext.type.order['role-pre'] = function (data) {
                const rolePriority = { teacher: 1, ta: 2, student: 3 };
                return rolePriority[data.toLowerCase()] || 4; // Default to 4 if the role is unknown
            };

            $('#enrollments-table').DataTable({
                paging: true,
                searching: true,
                ordering: true,
                info: true,
                columnDefs: [
                    { type: "role", targets: 3 }, // Apply custom sorting to the Role column (index 3)
                    { orderable: false, targets: [] } // Disable sorting for specific columns if needed
                ],
                order: [[3, "asc"], [0, "asc"]] // Default sort by Role (ascending), then by Name (ascending)
            });
        }
    }
}