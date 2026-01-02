import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["dialog"]
    
    open() {
        this.dialogTarget.showModal()
        const input = this.dialogTarget.querySelector("input, textarea, select")
        if (input) {
            input.value = ""
            input.focus()
        }
    }

    close() {
        this.dialogTarget.close()
    }
}
