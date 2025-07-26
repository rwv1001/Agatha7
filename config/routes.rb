Rails.application.routes.draw do
  # Home page
  root to: "welcome#default"

  # Admin login/logout
  get  "admin/login",  to: "admin#login"
  post "admin/login",  to: "admin#login"
  get  "admin/logout", to: "admin#logout"
  post "admin/logout", to: "admin#logout"

  # Welcome custom actions
  match "welcome/table_search",
        to: "welcome#table_search",
        via: [:get, :post]

  match "accessdenied", to: "admin#accessdenied", via: [:get, :post]

  # Static‐style welcome pages
  %w[
    admin
    accessdenied
    index
    termly
    mailing
    help
  ].each do |action|
    match action,
          to: "welcome##{action}",
          via: [:get, :post]
  end

  # People filter
  match "clear_filter",
        to: "people#clear_filter",
        via: [:get, :post]
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # RESTful resources
  resources :attendees
  resources :lectures
  resources :pcourses
  resources :student_programmes
  resources :programmes
  resources :people
  resources :courses
  resources :users
  resources :institutions
  resources :locations
  resources :tutorials
  resources :groups
  resources :tutorial_schedules
  resources :willing_tutors
  resources :willing_lecturers
  resources :email_templates
  resources :agatha_emails
  resources :agatha_files
  resources :maximum_tutorials

  # If you really need a catch‑all (NOT recommended!), you can uncomment:
  # match ":controller(/:action(/:id))",
  #       via: [:get, :post],
  #       format: false
end
