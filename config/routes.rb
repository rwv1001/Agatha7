Rails.application.routes.draw do
  # ActionCable mount
  mount ActionCable.server => '/cable'
  
  # Home page
  root to: "welcome#index"

  # Admin login/logout
  get  "admin/login",  to: "admin#login"
  post "admin/login",  to: "admin#login"
  get  "admin/logout", to: "admin#logout"
  post "admin/logout", to: "admin#logout"

  # Welcome custom actions
  match "welcome/table_search",
        to: "welcome#table_search",
        via: [:get, :post]

  match "welcome/add_external_filter",
        to: "welcome#add_external_filter",
        via: [:get, :post]

  match "welcome/update_external_filter",
        to: "welcome#update_external_filter",
        via: [:get, :post]

  match "welcome/update_group_filters",
        to: "welcome#update_group_filters",
        via: [:get, :post]

  match "welcome/update_formats",
        to: "welcome#update_formats",
        via: [:get, :post]

  match "welcome/new",
        to: "welcome#new",
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
  
  # RESTful resources with custom actions
  %w[
    attendees
    lectures
    pcourses
    student_programmes
    programmes
    people
    courses
    users
    institutions
    locations
    tutorials
    groups
    tutorial_schedules
    willing_tutors
    willing_lecturers
    email_templates
    agatha_emails
    agatha_files
    maximum_tutorials
  ].each do |resource|
    resources resource do
      collection do
        post :updater
        post :win_load
        post :win_unload
      end
    end
  end

  # If you really need a catch‑all (NOT recommended!), you can uncomment:
  # match ":controller(/:action(/:id))",
  #       via: [:get, :post],
  #       format: false
end
