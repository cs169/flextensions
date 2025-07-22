import { Controller } from "@hotwired/stimulus";
import DataTable from "datatables.net-bs5";
import "datatables.net-responsive";
import "datatables.net-responsive-bs5";
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
                                text: 'Copy Table to Clipboard',
                                title: null,
                                messageTop: null,
                                messageBottom: null,
                                info: false, // disables the notification
                                exportOptions: {
                                    columns: ':visible:not(.no-sort)',
                                    format: {
                                        body: function (data, row, column, node) {
                                            // For the Status column, use data-export attribute if present
                                            if (node && node.hasAttribute && node.hasAttribute('data-export')) {
                                                return node.getAttribute('data-export');
                                            }
                                            return data;
                                        }
                                    }
                                }
                            },
                            {
                                extend: 'csv',
                                text: 'Export as CSV',
                                filename: 'extension-requests',
                                exportOptions: {
                                    columns: ':visible:not(.no-sort)',
                                    format: {
                                        body: function (data, row, column, node) {
                                            // For the Status column, use data-export attribute if present
                                            if (node && node.hasAttribute && node.hasAttribute('data-export')) {
                                                return node.getAttribute('data-export');
                                            }
                                            return data;
                                        }
                                    }
                                }
                            },
                            'colvis'
                        ],
                    }
                }
            });

            if (searchQuery) {
                this.table.search(searchQuery).draw();
            }
        }
    }
}
