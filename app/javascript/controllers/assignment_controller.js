import { Controller } from "@hotwired/stimulus"
import DataTable from "datatables.net-bs5";
import "datatables.net-responsive";
import "datatables.net-responsive-bs5";

// Connects to data-controller="assignment"
export default class extends Controller {
  static targets = ["checkbox"]
  static values = {
    courseId: Number,
    bulkUrl: String,
    role: String,
    userId: Number
  }

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

  enableAll(event) {
    if (!confirm("Enable all assignments for this course? Assignments without a due date will be skipped.")) return;
    this._bulkUpdate(event.currentTarget, true);
  }

  disableAll(event) {
    if (!confirm("Disable all assignments for this course?")) return;
    this._bulkUpdate(event.currentTarget, false);
  }

  _bulkUpdate(button, enabled) {
    const url = this.bulkUrlValue;
    if (!url) {
      console.error("bulk-url-value is not set on the assignment controller element");
      return;
    }
    button.disabled = true;
    const token = document.querySelector('meta[name="csrf-token"]').content;
    fetch(url, {
      method: "PATCH",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": token,
      },
      body: JSON.stringify({
        course_id: this.courseIdValue,
        enabled: enabled,
        role: this.hasRoleValue ? this.roleValue : undefined,
        user_id: this.hasUserIdValue ? this.userIdValue : undefined,
      }),
    })
      .then(async (response) => {
        const data = await response.json();
        if (!response.ok) {
          if (data.redirect_to) {
            window.location.href = data.redirect_to;
            return;
          }
          throw new Error(data.error || "Failed to update assignments.");
        }
        const action = enabled ? "enabled" : "disabled";
        let message = `${data.updated_count} assignment(s) ${action}.`;
        if (data.skipped_count && data.skipped_count > 0) {
          message += ` ${data.skipped_count} skipped (missing due date).`;
        }
        flash("notice", message);
        location.reload();
      })
      .catch((error) => {
        flash("alert", error.message || "An error occurred while updating assignments.");
        button.disabled = false;
      });
  }

  sync(event) {
    const button = event.currentTarget;
    button.disabled = true;
    const courseId = this.courseIdValue;
    const token = document.querySelector('meta[name="csrf-token"]').content;
    fetch(`/courses/${courseId}/sync_assignments`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": token,
      },
    })
      .then((response) => {
        if (!response.ok) {
          throw new Error("Failed to sync assignments.");
        }
        return response.json();
      })
      .then((data) => {
        flash("notice", data.message || "Assignments synced successfully.");
        location.reload();
      })
      .catch((error) => {
        flash("alert", error.message || "An error occurred while syncing assignments.");
        location.reload();
      });
  }
}
