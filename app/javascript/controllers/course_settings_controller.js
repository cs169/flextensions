import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["emailField", "tab"]
  
  connect() {
    // Initialize the form state when controller is connected
    this.toggleEmailFields();
    
    // Add event listener to the email toggle
    const emailToggle = document.getElementById('enable-email');
    if (emailToggle) {
      emailToggle.addEventListener('change', this.toggleEmailFields.bind(this));
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
    
    // Update hidden field value
    const tabInput = document.getElementById('tab');
    if (tabInput) {
      tabInput.value = tabName;
    }
  }
} 