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

pin "datatables.net", to: "datatables-net.js"
pin "datatables.net-bs5", to: "datatables-net-bs5.js"
pin "datatables.net-responsive", to: "datatables-net-responsive.js"
pin "datatables.net-responsive-bs5", to: "datatables-net-responsive-bs5.js"
pin "datatables.net-buttons", to: "datatables-net-buttons.js"
pin "datatables.net-buttons-bs5", to: "datatables-net-buttons-bs5.js"
pin "datatables.net-buttons/js/buttons.html5.min.js", to: "datatables-net-buttons--js--buttons.html5.min.js.js"
pin "datatables.net-buttons/js/buttons.print.min.js", to: "datatables-net-buttons--js--buttons.print.min.js.js"
pin "datatables.net-buttons/js/buttons.colVis.min.js", to: "datatables-net-buttons--js--buttons.colVis.min.js.js"
