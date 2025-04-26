# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"
pin "@rails/ujs", to: "https://ga.jspm.io/npm:@rails/ujs@7.0.4/lib/assets/compiled/rails-ujs.js"
pin "rails-ujs-override", to: "rails-ujs-override.js"
pin "bootstrap", to: "bootstrap.min.js", preload: true
pin "@popperjs/core", to: "popper.js", preload: true
pin "assignments", to: "assignments.js"


# Pin DataTables and jQuery
pin "jquery", to: "https://ga.jspm.io/npm:jquery@3.7.1/dist/jquery.js"
pin "datatables.net", to: "https://ga.jspm.io/npm:datatables.net@1.13.6/js/jquery.dataTables.js"
#pin "datatables.net-dt", to: "https://ga.jspm.io/npm:datatables.net-dt@1.13.6/css/jquery.dataTables.css"

pin "datatables", to: "https://cdn.datatables.net/1.13.4/js/jquery.dataTables.min.js"
pin "requests", to: "requests.js"