import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
    static targets = ["toggleButton"];

    connect() {
        if (!$.fn.DataTable.isDataTable('#requests-table')) {
            this.table = $('#requests-table').DataTable({
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

        // Show only pending requests by default
        this.filterPendingRequests();

        // Add event listener for the toggle button
        this.toggleButtonTarget.addEventListener('click', () => {
            this.toggleRequests();
        });
    }

    filterPendingRequests() {
        // Hide rows that are not pending
        this.table.rows().every(function () {
            const status = $(this.node()).data('status');
            if (status !== 'pending') {
                $(this.node()).hide();
            }
        });
    }

    showAllRequests() {
        // Show all rows
        this.table.rows().every(function () {
            $(this.node()).show();
        });
    }

    toggleRequests() {
        const button = this.toggleButtonTarget;
        if (button.textContent === 'View All Requests') {
            this.showAllRequests();
            button.textContent = 'Show Pending Requests';
        } else {
            this.filterPendingRequests();
            button.textContent = 'View All Requests';
        }
    }
}
