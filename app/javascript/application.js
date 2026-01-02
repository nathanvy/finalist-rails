// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

// Close the mobile hamburger (checkbox hack)
function closeHamburger() {
  const toggle = document.getElementById("nav-toggle")
  if (toggle) toggle.checked = false
}

// Only runs if the request is actually proceeding (i.e., user clicked OK)
document.addEventListener("turbo:before-fetch-request", (e) => {
  const url = e.detail?.url
  if (!url) return

  // Matches: /lists/:id/items/clear_completed
  if (url.pathname.endsWith("/items/clear_completed")) {
    closeHamburger()
  }
})
