import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
    static targets = ["display", "form", "textarea", "content"];
    static values = { url: String };

    edit() {
        this.displayTarget.classList.add("d-none");
        this.formTarget.classList.remove("d-none");
        this.textareaTarget.focus();
    }

    cancel() {
        this.formTarget.classList.add("d-none");
        this.displayTarget.classList.remove("d-none");
    }

    async save() {
        const notes = this.textareaTarget.value;
        const token = document.querySelector('meta[name="csrf-token"]').content;

        try {
            const response = await fetch(this.urlValue, {
                method: "PATCH",
                headers: {
                    "Content-Type": "application/json",
                    "X-CSRF-Token": token,
                },
                body: JSON.stringify({ notes }),
            });

            const data = await response.json();

            if (response.ok && data.success) {
                if (notes.trim()) {
                    // Convert newlines to <br> tags and set as HTML
                    const escaped = notes
                        .replace(/&/g, "&amp;")
                        .replace(/</g, "&lt;")
                        .replace(/>/g, "&gt;");
                    const html = `<p>${escaped.replace(/\n\n+/g, "</p>\n\n<p>").replace(/\n/g, "<br>")}</p>`;
                    this.contentTarget.innerHTML = html;
                } else {
                    this.contentTarget.innerHTML =
                        '<span class="text-muted">No notes yet.</span>';
                }
                this.formTarget.classList.add("d-none");
                this.displayTarget.classList.remove("d-none");
                this._dispatchFlash("notice", "Notes saved successfully.");
            } else {
                this._dispatchFlash(
                    "alert",
                    data.error || "Failed to save notes."
                );
            }
        } catch {
            this._dispatchFlash("alert", "Network error. Please try again.");
        }
    }

    _dispatchFlash(type, message) {
        window.dispatchEvent(
            new CustomEvent("flash", { detail: { type, message } })
        );
    }
}
