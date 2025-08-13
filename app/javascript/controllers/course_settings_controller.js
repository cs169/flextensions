import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["emailField", "tab", "gradescopeField", "slackWebhookField"];

  connect() {
    this.toggleEmailFields();
    this.toggleSlackWebhookField();
    this.toggleGradescopeFields();

    const gradescopeToggle = document.getElementById('enable-gradescope');
    if (gradescopeToggle) {
      gradescopeToggle.addEventListener('change', this.toggleGradescopeFields.bind(this));
    }

    const emailToggle = document.getElementById('enable-email');
    if (emailToggle) {
      emailToggle.addEventListener('change', this.toggleEmailFields.bind(this));
    }

    const slackToggle = document.getElementById('enable-slack');
    if (slackToggle) {
      slackToggle.addEventListener('change', this.toggleSlackWebhookField.bind(this));
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

  toggleSlackWebhookField() {
    const slackToggle = document.getElementById('enable-slack');
    const slackWebhookField = document.getElementById('slack-webhook');

    if (slackToggle && slackWebhookField) {
      slackWebhookField.disabled = !slackToggle.checked;
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
