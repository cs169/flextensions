import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["emailField", "gradescopeField", "tab"]
  
  connect() {
    this.toggleEmailFields();
    this.toggleGradescopeFields();

    const gradescopeToggle = document.getElementById('enable-gradescope');
    if (gradescopeToggle) {
      gradescopeToggle.addEventListener('change', this.toggleGradescopeFields.bind(this));
    }
    
    const emailToggle = document.getElementById('enable-email');
    if (emailToggle) {
      emailToggle.addEventListener('change', this.toggleEmailFields.bind(this));
    }
  }

  toggleGradescopeFields() {
    const gradescopeToggle = document.getElementById('enable-gradescope');
    const gradescopeCourseUrlField = document.getElementById('gradescope-course-url');
    
    if (gradescopeToggle && gradescopeCourseUrlField) {
      const isEnabled = gradescopeToggle.checked;
      gradescopeCourseUrlField.disabled = !isEnabled;
    }
  }
  
  toggleEmailFields() {
    const emailToggle = document.getElementById('enable-email');
    const replyEmailField = document.getElementById('reply-email');
    
    if (emailToggle && replyEmailField) {
      const isEnabled = emailToggle.checked;
      replyEmailField.disabled = !isEnabled;
    }
  }
  
  updateUrlParam(event) {
    const tabName = event.currentTarget.dataset.tab;
    const url = new URL(window.location);
    url.searchParams.set('tab', tabName);
    window.history.pushState({}, '', url);
    
    const tabInput = document.getElementById('tab');
    if (tabInput) {
      tabInput.value = tabName;
    }
  }
} 