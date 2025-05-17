# config/importmap.rb
# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"

pin_all_from "app/javascript/controllers", under: "controllers"

pin "@rails/ujs", to: "https://ga.jspm.io/npm:@rails/ujs@7.0.4/lib/assets/compiled/rails-ujs.js"
pin "rails-ujs-override", to: "rails-ujs-override.js"

# Bootstrap and dependencies
pin "bootstrap", to: "bootstrap.min.js", preload: true
pin "@popperjs/core", to: "popper.js", preload: true
pin "jquery" # @3.7.1
pin "color-modes"
pin "datatables.net" # @2.3.1
pin "datatables.net-bs5" # @2.2.2
pin "datatables.net-responsive-bs5" # @3.0.4
pin "datatables.net-responsive" # @3.0.4
pin "datatables.net-buttons" # @3.2.3
