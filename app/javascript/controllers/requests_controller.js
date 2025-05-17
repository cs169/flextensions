import { Controller } from "@hotwired/stimulus";
import DataTable from "datatables.net-bs5";
import "datatables.net-buttons";
import "datatables.net-buttons-bs5";
import "datatables.net-buttons/js/buttons.html5.min.js";
import "datatables.net-buttons/js/buttons.print.min.js";
import "datatables.net-buttons/js/buttons.colVis.min.js";

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
                layout: {
                    topStart: {
                        buttons: [
                            {
                                extend: 'copy',
                                title: null,
                                messageTop: null,
                                messageBottom: null,
                                info: false // disables the notification
                            },
                            'csv',
                            'colvis'
                        ],
                        search: {}
                    }
                }
            });

            if (searchQuery) {
                this.table.search(searchQuery).draw();
            }
        }
    }
}
