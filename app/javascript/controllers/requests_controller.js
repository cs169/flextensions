import { Controller } from "@hotwired/stimulus";
import DataTable from "datatables.net-bs5";
import "datatables.net-responsive";
import "datatables.net-responsive-bs5";
import "datatables.net-buttons";
import "datatables.net-buttons-bs5";

export default class extends Controller {
    connect() {
        if (!DataTable.isDataTable('#requests-table')) {
            const searchQuery = this.element.dataset.searchQuery;

            this.table = new DataTable('#requests-table', {
                paging: true,
                searching: true,
                ordering: true,
                info: true,
                responsive: true,
                columnDefs: [
                    { orderable: false, targets: 'no-sort' },
                    { type: "date", targets: [3, 4, 5] }
                ],
                order: [[3, "asc"]],
                dom: 'Bfrtip',
                buttons: [
                    {
                        extend: 'copy',
                        exportOptions: { columns: ':not(.no-export)' }
                    },
                    {
                        extend: 'excel',
                        exportOptions: { columns: ':not(.no-export)' }
                    },
                    {
                        extend: 'pdf',
                        exportOptions: { columns: ':not(.no-export)' }
                    },
                    {
                        extend: 'csv',
                        exportOptions: { columns: ':not(.no-export)' }
                    },
                    'colvis'
                ]
            });

            if (searchQuery) {
                this.table.search(searchQuery).draw();
            }
        }
    }
}
