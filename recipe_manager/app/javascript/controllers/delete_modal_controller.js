import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["dialog", "message"]

  confirm(event) {
    if (this.confirmed) {
      this.confirmed = false
      return
    }

    event.preventDefault()
    this.form = event.target

    if (this.hasMessageTarget) {
      this.messageTarget.textContent = `Remove ${event.params.item} from this recipe?`
    }

    this.dialogTarget.showModal()
  }

  cancel() {
    this.dialogTarget.close()
    this.form = null
  }

  delete() {
    this.confirmed = true
    this.dialogTarget.close()
    this.form.requestSubmit()
  }
}
