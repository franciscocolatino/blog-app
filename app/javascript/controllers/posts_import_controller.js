import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['file', 'submitButton'];

  connect() {
    this.fileTarget.addEventListener('change', this.toggleSubmitButton.bind(this));
  }
  
  toggleSubmitButton() {
    if (this.fileTarget.files.length > 0) {
      this.submitButtonTarget.disabled = false;
    } else {
      this.submitButtonTarget.disabled = true;
    }
  }
}
