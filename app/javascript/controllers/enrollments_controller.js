import { Controller } from "@hotwired/stimulus";
import DataTable from "datatables.net-bs5";
import "datatables.net-responsive";
import "datatables.net-responsive-bs5";
import { syncResource } from "../helpers/api_helpers";

export default class extends Controller {
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
				// responsive: true,
				columns: [
					null, // Name
					null, // Email
					null, // Section
					{ orderDataType: 'role-pre' } // Role column (custom sort)
				],
				order: [[3, 'des'], [0, 'asc']] // Sort Role first, then Name
			});
		}
	}

	sync(event) {
		const button = event.currentTarget;
		button.disabled = true;
		const courseId = this.courseIdValue;
		
		syncResource(
			courseId, 
			'sync_enrollments', 
			'Enrollments synced successfully.', 
			'Failed to sync enrollments.'
		);
	}
}