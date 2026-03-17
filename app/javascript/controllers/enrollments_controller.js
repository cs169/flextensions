import { Controller } from "@hotwired/stimulus";
import DataTable from "datatables.net-bs5";
import "datatables.net-responsive";
import "datatables.net-responsive-bs5";

export default class extends Controller {
	static targets = ["checkbox"]
	static values = { courseId: Number }

	connect() {
		if (!DataTable.isDataTable('#enrollments-table')) {
			// Define a custom sorting function for the Role column
			DataTable.ext.type.order['role-pre'] = function (data) {
				const rolePriority = { teacher: 4, ta: 2, student: 3 };
				if (typeof data !== 'string') {
					data = String(data).trim();
				}
				return rolePriority[data.toLowerCase()] || 4;
			};

			new DataTable('#enrollments-table', {
				paging: true,
				searching: true,
				ordering: true,
				info: true,
				responsive: true,
				pageLength: 500,
				lengthMenu: [[-1, 25, 50, 100, 500], ["All", 25, 50, 100, 500]],
				columns: document.querySelectorAll('#enrollments-table thead th').length === 5
					? [null, null, null, { orderDataType: 'role-pre' }, null]
					: [null, null, null, { orderDataType: 'role-pre' }],
				order: [[3, 'des'], [0, 'asc']] // Sort Role first, then Name
			});
		}
	}

	async toggleExtended(event) {
		const checkbox = event.currentTarget;
		const url = checkbox.dataset.url;
		const allowExtended = checkbox.checked;

		try {
			const token = document.querySelector('meta[name="csrf-token"]')?.content || '';

			const response = await fetch(url, {
				method: "PATCH",
				headers: {
					"Content-Type": "application/json",
					"X-CSRF-Token": token,
				},
				body: JSON.stringify({
					allow_extended_requests: allowExtended,
				}),
			});

			const data = await response.json();

			if (!response.ok) {
				if (data.redirect_to) {
					window.location.href = data.redirect_to;
					return;
				}
				throw new Error(data.error || 'Error updating enrollment');
			}

			const td = checkbox.closest('td');
			if (td) td.dataset.order = allowExtended ? '1' : '0';
			this._dispatchFlash('notice', `Extended requests ${allowExtended ? 'enabled' : 'disabled'}.`);
		} catch (error) {
			console.error("Error updating enrollment:", error);
			checkbox.checked = !allowExtended;
		}
	}

	_dispatchFlash(type, message) {
		window.dispatchEvent(new CustomEvent('flash', { detail: { type: type, message: message } }));
	}

	sync() {
		const button = event.currentTarget;
		button.disabled = true;
		const courseId = this.courseIdValue;
		const token = document.querySelector('meta[name="csrf-token"]').content;		fetch(`/courses/${courseId}/sync_enrollments`, {
		  method: "POST",
		  headers: {
			"Content-Type": "application/json",
			"X-CSRF-Token": token,
		  },
		})
		  .then((response) => {
			if (!response.ok) {
			  throw new Error(`Failed to sync enrollments. ${response.status} - ${response.statusText}`);
			}
			return response.json();
		  })
		  .then((data) => {
			flash("notice", data.message || "Enrollments synced successfully.");
			location.reload();
		  })
		  .catch((error) => {
			flash("alert", error.message || "An error occurred while syncing enrollments.");
			location.reload();
		});
	  }
}
