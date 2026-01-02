// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

window.togglenav = function togglenav() {
    const nav = document.getElementById("nav");
    if (!nav) return;
    nav.classList.toggle("vis");
};
