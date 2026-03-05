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
    static targets = ["pendingBadge"]

    connect() {
        if (!DataTable.isDataTable('#requests-table')) {
            const searchQuery = this.element.dataset.searchQuery;
            const readonlyToken = this.element.dataset.readonlyToken;
            const courseId = this.element.dataset.courseId;

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
                                extend: 'collection',
                                text: 'Copy Google Sheets Import to Clipboard',
                                buttons: [
                                    {
                                        text: 'All Requests',
                                        className: 'dropdown-item',
                                        action: function () {
                                            const url = `https://${window.location.host}/courses/${courseId}/requests/export.csv?readonly_api_token=${readonlyToken}`;
                                            const formula = `=IMPORTDATA("${url}")`;
                                            navigator.clipboard.writeText(formula);
                                        }
                                    },
                                    {
                                        text: 'Pending Requests',
                                        className: 'dropdown-item',
                                        action: function () {
                                            const url = `https://flextensions-sandbox-bbbb505fb40a.herokuapp.com/courses/${courseId}/requests/export.csv?readonly_api_token=${readonlyToken}&status=pending`;
                                            const formula = `=IMPORTDATA("${url}")`;
                                            navigator.clipboard.writeText(formula);
                                        }
                                    }
                                ]
                            },
                            {
                                extend: 'copy',
                                text: 'Copy Table to Clipboard',
                                title: null,
                                messageTop: null,
                                messageBottom: null,
                                info: false,
                                exportOptions: {
                                    columns: ':visible:not(.no-sort)',
                                    format: {
                                        body: function (data, row, column, node) {
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

    approve(event) {
        this._submitAction(event.currentTarget);
    }

    reject(event) {
        this._submitAction(event.currentTarget);
    }

    async _submitAction(button) {
        const url = button.dataset.url;
        const btnGroup = button.closest('.btn-group');
        const allBtns = btnGroup ? btnGroup.querySelectorAll('button') : [button];
        allBtns.forEach(b => b.disabled = true);

        try {
            const token = document.querySelector('meta[name="csrf-token"]').content;
            const response = await fetch(url, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json', 'X-CSRF-Token': token }
            });
            const data = await response.json();

            if (response.ok && data.success) {
                this._handleSuccess(button, data);
                window.dispatchEvent(new CustomEvent('flash', { detail: { type: 'notice', message: data.message } }));
            } else {
                allBtns.forEach(b => b.disabled = false);
                window.dispatchEvent(new CustomEvent('flash', { detail: { type: 'alert', message: data.message || 'An error occurred.' } }));
            }
        } catch {
            allBtns.forEach(b => b.disabled = false);
            window.dispatchEvent(new CustomEvent('flash', { detail: { type: 'alert', message: 'Network error. Please try again.' } }));
        }
    }

    _handleSuccess(button, data) {
        const tr = button.closest('tr');
        const showAll = this.element.dataset.showAll === 'true';

        if (showAll) {
            const statusTd = tr.querySelector('td[data-export]');
            if (statusTd) {
                const isApproved = data.new_status === 'approved';
                const badgeClass = isApproved ? 'text-bg-success' : 'text-bg-danger';
                const label = isApproved ? 'Approved' : 'Denied';
                statusTd.innerHTML = `<span class="badge ${badgeClass}">${label}</span>`;
            }
            const btnGroup = button.closest('.btn-group');
            if (btnGroup) btnGroup.remove();
            if (this.table) this.table.row(tr).invalidate().draw(false);
        } else {
            if (this.table) {
                this.table.row(tr).remove().draw(false);
            } else {
                tr.remove();
            }
        }

        if (this.hasPendingBadgeTarget) {
            this.pendingBadgeTarget.textContent = data.pending_count;
        }
    }
}
