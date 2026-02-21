import { Controller } from "@hotwired/stimulus";
import DataTable from "datatables.net-bs5";
import "datatables.net-responsive";
import "datatables.net-responsive-bs5";

export default class extends Controller {
	static targets = ["checkbox"]
	static values = { courseId: Number }

	connect() {
		this.checkboxTargets.forEach((checkbox) => {
			checkbox.addEventListener("change", (event) => this.toggleExtended(event, checkbox))
		})

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
				columns: [
					null, // Name
					null, // Email
					null, // Section
					{ orderDataType: 'role-pre' }, // Role column (custom sort)
					null,
				],
				order: [[3, 'des'], [0, 'asc']] // Sort Role first, then Name
			});
		}
	}

	async toggleExtended(event, checkbox) {
		const enrollmentId = checkbox.dataset.enrollmentId;
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

			console.log(`Enrollment ${enrollmentId} allow_extended_requests: ${allowExtended}`);
		} catch (error) {
			console.error("Error updating enrollment:", error);
			checkbox.checked = !allowExtended;
		}
	}

	sync() {
		const button = event.currentTarget;
		button.disabled = true;
		const courseId = this.courseIdValue;
		const token = document.querySelector('meta[name="csrf-token"]')?.content || '';
		fetch(`/courses/${courseId}/sync_enrollments`, {
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
