# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin "@rails/ujs", to: "https://ga.jspm.io/npm:@rails/ujs@7.0.6/lib/assets/compiled/rails-ujs.js"

pin_all_from "app/javascript/controllers", under: "controllers"
pin "display_format", to: "display_format.js", preload: true

pin "edit", to: "edit.js", preload: true
pin "group_filters", to: "group_filters.js", preload: true

pin "search_ctl", to: "search_ctl.js", preload: true
pin "template", to: "template.js", preload: true
pin "jquery", to: "https://ga.jspm.io/npm:jquery@3.6.4/dist/jquery.js"
