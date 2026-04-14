import { Controller } from "@hotwired/stimulus"
import DataTable from "datatables.net-bs5";
import "datatables.net-responsive";
import "datatables.net-responsive-bs5";

// Connects to data-controller="assignment"
export default class extends Controller {
  static targets = ["checkbox", "syncBtn", "syncLabel", "syncSpinner"]
  static values = { courseId: Number }

  connect() {
    this.checkboxTargets.forEach((checkbox) => {
      checkbox.addEventListener("change", (event) => this.toggleAssignment(event, checkbox))
    })

    if (!DataTable.isDataTable('#assignments-table')) {
			new DataTable('#assignments-table', {
				paging: true,
				searching: true,
				ordering: true,
				info: true,
				responsive: true,
			});
		}
  }

  async toggleAssignment(event, checkbox) {
    const assignmentId = checkbox.dataset.assignmentId;
    const url = checkbox.dataset.url;
    const enabled = checkbox.checked;
    const role = checkbox.dataset.role; // Get the role
    const userId = checkbox.dataset.userId; // Get the user ID

    try {
      const token = document.querySelector('meta[name="csrf-token"]').content;

      const response = await fetch(url, {
        method: "PATCH",
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": token,
        },
        body: JSON.stringify({
          enabled: enabled,
          role: role, // Pass the role
          user_id: userId, // Pass the user ID
        }),
      });

      const data = await response.json();

      if (!response.ok) {
        if (data.redirect_to) {
          window.location.href = data.redirect_to;
          return;
        }
        throw new Error(data.error || 'Error updating assignment');
      }

      console.log(`Assignment ${assignmentId} enabled: ${enabled}`);
    } catch (error) {
      console.error("Error updating assignment:", error);
      checkbox.checked = !enabled; // rollback checkbox if error
    }
  }

  async sync() {
    const button = this.syncBtnTarget;
    const label = this.syncLabelTarget;
    const spinner = this.syncSpinnerTarget;
    const courseId = this.courseIdValue;
    const token = document.querySelector('meta[name="csrf-token"]').content;

    button.disabled = true;
    label.textContent = "Syncing...";
    spinner.classList.remove("d-none");

    try {
      const statusBefore = await this._fetchJson(`/courses/${courseId}/sync_status`);
      const beforeTs = statusBefore.assignments_synced_at;

      const response = await fetch(`/courses/${courseId}/sync_assignments`, {
        method: "POST",
        headers: { "Content-Type": "application/json", "X-CSRF-Token": token },
      });

      if (!response.ok) throw new Error(`Failed to sync assignments. ${response.status}`);

      await this._pollUntilDone(courseId, "assignments_synced_at", beforeTs);

      flash("notice", "Assignments synced successfully.");
      location.reload();
    } catch (error) {
      flash("alert", error.message || "An error occurred while syncing assignments.");
      button.disabled = false;
      label.textContent = "Sync Assignments";
      spinner.classList.add("d-none");
    }
  }

  async _pollUntilDone(courseId, key, beforeTs, intervalMs = 1000, timeoutMs = 60000) {
    const deadline = Date.now() + timeoutMs;
    while (Date.now() < deadline) {
      await new Promise(resolve => setTimeout(resolve, intervalMs));
      const status = await fetch(`/courses/${courseId}/sync_status`).then(r => r.json());
      if (status[key] && status[key] !== beforeTs) return;
    }
    throw new Error("Sync timed out. Please refresh the page.");
  }
}
