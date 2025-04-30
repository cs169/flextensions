import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="extension-form"
export default class extends Controller {
  static targets = ["daysDisplay", "dueDateInput", "assignmentSelect"]

  connect() {
    if (this.assignmentSelectTarget.dataset.updateOnly === "true") {
      this._initializeUpdateOnlyMode();
    } else {
      this._initializeNormalMode();
    }
    this._setupListeners();
  }

  // Public method so that the action "input->extension-form#updateDays" works.
  updateDays() {
    this._updateDays();
  }

  _updateDays() {
    const newDueDate = new Date(this.dueDateInputTarget.value);
    const diffTime = newDueDate - this.originalDueDate;
    const diffDays = Math.round(diffTime / (1000 * 60 * 60 * 24));
    this.daysDisplayTarget.textContent = isNaN(diffDays) ? '' : Math.max(0, diffDays);
  }

  updateAssignment() {
    const selectedOption = this.assignmentSelectTarget.selectedOptions[0];
    const newOriginalDueDate = selectedOption.dataset.originalDueDate;
    const newLateDueDate = selectedOption.dataset.originalLateDueDate;
  
    if (newOriginalDueDate) {
      const minDate = new Date(newOriginalDueDate.split(" at ")[0]);
      minDate.setDate(minDate.getDate() + 1);
  
      this.dueDateInputTarget.min = this._toDateString(minDate);
      this.dueDateInputTarget.value = this._toDateString(minDate);
  
      this.dueDateInputTarget.dataset.originalDueDate = newOriginalDueDate;
      this.originalDueDate = new Date(newOriginalDueDate.split(" at ")[0]);

      // New code to update the due_time hidden field
      const parts = newOriginalDueDate.split(" at ");
      const timePart = parts[1] || '';
      const dueTimeInput = document.getElementById("request_due_time");
      if (dueTimeInput && timePart) {
        dueTimeInput.value = this._convertTimeTo24Hour(timePart);
      }

      this._updateDays();
  
      document.getElementById("due-date").textContent = newOriginalDueDate || '';
      document.getElementById("late-due-date").textContent = newLateDueDate || '';
    }
  }

  _toDateString(date) {
    return date.toISOString().split("T")[0];
  }

  _convertTimeTo24Hour(timeStr) {
    const [time, modifier] = timeStr.split(' ');
    let [hours, minutes] = time.split(':');
    hours = parseInt(hours, 10);
    if (modifier === 'PM' && hours !== 12) {
      hours += 12;
    }
    if (modifier === 'AM' && hours === 12) {
      hours = 0;
    }
    return `${hours.toString().padStart(2, '0')}:${minutes}`;
  }

  _initializeUpdateOnlyMode() {
    this.originalDueDateStr =
      this.dueDateInputTarget.dataset.originalDueDate ||
      document.getElementById("edit-request-requested-due-date").value;
    this.originalDueDate = new Date(this.originalDueDateStr);
    const minDate = new Date(this.originalDueDate);
    minDate.setDate(minDate.getDate() + 1);
    this.dueDateInputTarget.min = this._toDateString(minDate);
    let currentDueDate = new Date(this.dueDateInputTarget.value);
    if (currentDueDate < minDate) {
      this.dueDateInputTarget.value = this._toDateString(minDate);
    }
    this._updateDays();
  }

  _initializeNormalMode() {
    this.originalDueDateStr = this.dueDateInputTarget.dataset.originalDueDate;
    if (this.originalDueDateStr && this.originalDueDateStr.includes(" at ")) {
      this.originalDueDate = new Date(
        this.originalDueDateStr.split(" at ")[0]
      );
    } else {
      this.originalDueDateStr = this.dueDateInputTarget.value;
      this.originalDueDate = new Date(this.originalDueDateStr);
    }
    if (this.originalDueDateStr) {
      const minDate = new Date(
        this.originalDueDateStr.split(" at ")[0]
      );
      minDate.setDate(minDate.getDate() + 1);
      this.dueDateInputTarget.min = this._toDateString(minDate);
      this.dueDateInputTarget.value = this._toDateString(minDate);
      const currentDueDate = new Date(this.dueDateInputTarget.value);
      if (currentDueDate < minDate) {
        this.dueDateInputTarget.value = this._toDateString(minDate);
      }
      this._updateDays();
    }
  }

  _setupListeners() {
    this.dueDateInputTarget.addEventListener("input", () =>
      this._updateDays()
    );
    this.assignmentSelectTarget.addEventListener("change", () =>
      this.updateAssignment()
    );
  }
}