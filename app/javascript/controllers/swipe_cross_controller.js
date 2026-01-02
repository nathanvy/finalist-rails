import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["form", "checkbox"]

  connect() {
    // swipe tuning
    this.minSwipePx = 40
    this.maxVerticalPx = 30

    // state
    this.startX = null
    this.startY = null
    this.tracking = false
    this.pointerId = null

    this.onPointerDown = this.pointerDown.bind(this)
    this.onPointerMove = this.pointerMove.bind(this)
    this.onPointerUp = this.pointerUp.bind(this)
    this.onPointerCancel = this.pointerCancel.bind(this)

    this.element.addEventListener("pointerdown", this.onPointerDown)
    this.element.addEventListener("pointermove", this.onPointerMove)
    this.element.addEventListener("pointerup", this.onPointerUp)
    this.element.addEventListener("pointercancel", this.onPointerCancel)
  }

  disconnect() {
    this.element.removeEventListener("pointerdown", this.onPointerDown)
    this.element.removeEventListener("pointermove", this.onPointerMove)
    this.element.removeEventListener("pointerup", this.onPointerUp)
    this.element.removeEventListener("pointercancel", this.onPointerCancel)
  }

  pointerDown(e) {
    // Only care about touch/pen; ignore mouse.
    if (e.pointerType === "mouse") return

    // Don’t treat interactions with controls as swipes.
    if (e.target.closest("a, button, input, label, textarea, select")) return

    this.pointerId = e.pointerId
    this.startX = e.clientX
    this.startY = e.clientY
    this.lastX = e.clientX
    this.lastY = e.clientY
    this.tracking = true
  }

  pointerMove(e) {
    if (!this.tracking) return
    if (this.pointerId !== e.pointerId) return

    this.lastX = e.clientX
    this.lastY = e.clientY

    const dx = this.lastX - this.startX
    const dy = this.lastY - this.startY

    // If it’s clearly a vertical scroll, abandon swipe tracking.
    if (Math.abs(dy) > this.maxVerticalPx && Math.abs(dy) > Math.abs(dx)) {
      this.tracking = false
    }
  }

  pointerUp(e) {
    if (!this.tracking) return
    if (this.pointerId !== e.pointerId) return
    this.tracking = false

    const dx = this.lastX - this.startX
    const dy = this.lastY - this.startY

    if (Math.abs(dy) > this.maxVerticalPx) return
    if (Math.abs(dx) < this.minSwipePx) return

    this.toggle()
  }

  pointerCancel(e) {
    if (this.pointerId === e.pointerId) {
      this.tracking = false
    }
  }

  toggle() {
    if (!this.hasFormTarget || !this.hasCheckboxTarget) return

    // Flip the checkbox and submit the existing Turbo form.
    this.checkboxTarget.checked = !this.checkboxTarget.checked
    this.formTarget.requestSubmit()
  }
}
