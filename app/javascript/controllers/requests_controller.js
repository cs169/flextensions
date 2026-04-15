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
    static targets = ["pendingBadge", "rowCheckbox", "selectAllCheckbox", "massApproveButton", "massRejectButton"];

    connect() {
        const tableElement = this.element.querySelector('#requests-table');
        if (!tableElement) return;

        if (!DataTable.isDataTable('#requests-table')) {
            const searchQuery = this.element.dataset.searchQuery;
            const readonlyToken = this.element.dataset.readonlyToken;
            const courseId = this.element.dataset.courseId;
            const controller = this;

            this.table = new DataTable('#requests-table', {
                paging: true,
                searching: true,
                ordering: true,
                info: true,
                responsive: true,
                columnDefs: [
                    { orderable: false, targets: 'no-sort' },
                    { type: "date", targets: [5, 6, 7] },
                    { visible: false, targets: [0] }
                ],
                order: [[5, "asc"]],
                layout: {
                    topStart: {
                        buttons: [
                            {
                                extend: 'colvis',
                                text: '<i class="fas fa-columns me-1"></i>Columns',
                                columns: ':not(.no-sort)'
                            },
                            {
                                text: '<i class="fas fa-edit me-1"></i>Batch Edit',
                                action: function (e, dt, node, config) {
                                    const col = dt.column(0);
                                    const willShow = !col.visible();
                                    col.visible(willShow);

                                    const batchActions = controller.element.querySelector('.batch-actions');
                                    if (batchActions) {
                                        batchActions.classList.toggle('d-none', !willShow);
                                    }

                                    if (!willShow) {
                                        controller._selectableCheckboxes().forEach((cb) => { cb.checked = false; });
                                        controller._syncSelectionControls();
                                    }

                                    const btnEl = node.nodeType === 1 ? node : (node[0] || node);
                                    btnEl.classList.toggle('active', willShow);
                                    btnEl.innerHTML = willShow
                                        ? '<i class="fas fa-times me-1"></i>Exit Batch Edit'
                                        : '<i class="fas fa-edit me-1"></i>Batch Edit';
                                }
                            }
                        ]
                    }
                }
            });

            if (searchQuery) {
                this.table.search(searchQuery).draw();
            }
        }

        this._syncSelectionControls();
    }

    approve(event) {
        this._submitSingleAction(event.currentTarget);
    }

    reject(event) {
        this._submitSingleAction(event.currentTarget);
    }

    toggleSelectAll(event) {
        const checked = event.currentTarget.checked;
        this._selectableCheckboxes().forEach((checkbox) => {
            checkbox.checked = checked;
        });
        this._syncSelectionControls();
    }

    toggleRowSelection() {
        this._syncSelectionControls();
    }

    massApprove() {
        this._submitMassAction(this.element.dataset.massApproveUrl);
    }

    massReject() {
        this._submitMassAction(this.element.dataset.massRejectUrl);
    }

    async _submitSingleAction(button) {
        const url = button.dataset.url;
        const container = button.closest('.request-actions');
        const allBtns = container ? container.querySelectorAll('button') : [button];
        allBtns.forEach((btn) => { btn.disabled = true; });

        try {
            const token = document.querySelector('meta[name="csrf-token"]').content;
            const response = await fetch(url, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json', 'X-CSRF-Token': token }
            });
            const data = await response.json();

            if (response.ok && data.success) {
                this._handleSingleSuccess(button, data);
                this._dispatchFlash('notice', data.message);
            } else {
                allBtns.forEach((btn) => { btn.disabled = false; });
                this._dispatchFlash('alert', data.message || 'An error occurred.');
            }
        } catch {
            allBtns.forEach((btn) => { btn.disabled = false; });
            this._dispatchFlash('alert', 'Network error. Please try again.');
        }
    }

    async _submitMassAction(url) {
        const selectedIds = this._selectedRequestIds();
        if (!selectedIds.length) {
            this._dispatchFlash('alert', 'Please select at least one request.');
            return;
        }

        this._setMassButtonsDisabled(true);

        try {
            const token = document.querySelector('meta[name="csrf-token"]').content;
            const response = await fetch(url, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json', 'X-CSRF-Token': token },
                body: JSON.stringify({ request_ids: selectedIds })
            });
            const data = await response.json();

            if (response.ok && data.success) {
                this._handleMassSuccess(data);
                this._dispatchFlash('notice', data.message);
            } else {
                this._dispatchFlash('alert', data.message || 'An error occurred.');
            }
        } catch {
            this._dispatchFlash('alert', 'Network error. Please try again.');
        } finally {
            this._syncSelectionControls();
        }
    }

    _handleSingleSuccess(button, data) {
        const tr = button.closest('tr');
        this._applyRowOutcome(tr, data.new_status);
        if (this.table) {
            this.table.draw(false);
        }
        this._updatePendingCount(data.pending_count);
        this._syncSelectionControls();
    }

    _handleMassSuccess(data) {
        const processedIds = Array.isArray(data.processed_ids) ? data.processed_ids : [];
        processedIds.forEach((id) => {
            const checkbox = this.rowCheckboxTargets.find((cb) => Number(cb.dataset.requestId) === Number(id));
            if (!checkbox) return;

            const tr = checkbox.closest('tr');
            if (!tr) return;
            this._applyRowOutcome(tr, data.new_status);
        });

        if (this.table) {
            this.table.draw(false);
        }

        this._updatePendingCount(data.pending_count);
    }

    _applyRowOutcome(tr, newStatus) {
        if (!tr) return;
        const showAll = this.element.dataset.showAll === 'true';

        if (showAll) {
            const statusTd = tr.querySelector('td[data-export]');
            if (statusTd) {
                const isApproved = newStatus === 'approved';
                const badgeClass = isApproved ? 'text-bg-success' : 'text-bg-danger';
                const label = isApproved ? 'Approved' : 'Denied';
                statusTd.setAttribute('data-export', label);
                statusTd.innerHTML = `<span class="badge ${badgeClass}">${label}</span>`;
            }

            const requestActions = tr.querySelector('.request-actions');
            if (requestActions) requestActions.remove();

            const checkbox = tr.querySelector('input[data-request-id]');
            if (checkbox) {
                checkbox.checked = false;
                checkbox.disabled = true;
            }

            if (this.table) {
                this.table.row(tr).invalidate();
            }
        } else if (this.table) {
            this.table.row(tr).remove();
        } else {
            tr.remove();
        }
    }

    _selectedRequestIds() {
        return this._selectableCheckboxes()
            .filter((checkbox) => checkbox.checked)
            .map((checkbox) => Number(checkbox.dataset.requestId))
            .filter((id) => Number.isInteger(id) && id > 0);
    }

    _selectableCheckboxes() {
        return this.rowCheckboxTargets.filter((checkbox) => !checkbox.disabled);
    }

    _syncSelectionControls() {
        const selectable = this._selectableCheckboxes();
        const selectedCount = selectable.filter((checkbox) => checkbox.checked).length;

        if (this.hasSelectAllCheckboxTarget) {
            if (!selectable.length) {
                this.selectAllCheckboxTarget.checked = false;
                this.selectAllCheckboxTarget.indeterminate = false;
                this.selectAllCheckboxTarget.disabled = true;
            } else {
                this.selectAllCheckboxTarget.disabled = false;
                this.selectAllCheckboxTarget.checked = selectedCount === selectable.length;
                this.selectAllCheckboxTarget.indeterminate = selectedCount > 0 && selectedCount < selectable.length;
            }
        }

        this._setMassButtonsDisabled(selectedCount === 0);
    }

    _setMassButtonsDisabled(disabled) {
        if (this.hasMassApproveButtonTarget) this.massApproveButtonTarget.disabled = disabled;
        if (this.hasMassRejectButtonTarget) this.massRejectButtonTarget.disabled = disabled;
    }

    _updatePendingCount(pendingCount) {
        if (this.hasPendingBadgeTarget) {
            this.pendingBadgeTarget.textContent = pendingCount;
        }
    }

    _dispatchFlash(type, message) {
        window.dispatchEvent(new CustomEvent('flash', { detail: { type: type, message: message } }));
    }
}
