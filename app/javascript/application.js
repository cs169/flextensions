// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails

import "color-modes"
import jQuery from "jquery"
window.$ = jQuery
window.jQuery = jQuery
import "@hotwired/stimulus"
import "@hotwired/stimulus-loading"
import "controllers"
import "@rails/ujs"
import "rails-ujs-override"
import "@popperjs/core"
import "bootstrap"