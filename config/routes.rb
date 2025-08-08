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

  match "welcome/order_toggle",
        to: "welcome#order_toggle",
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
        
  # Session counter actions for welcome page
  get "welcome/get_counter", to: "welcome#get_counter"
  post "welcome/increment_counter", to: "welcome#increment_counter"
  post "welcome/reset_counter", to: "welcome#reset_counter"

  match "welcome/multi_table_create",
        to: "welcome#multi_table_create",
        via: [:get, :post]

  match "welcome/new",
        to: "welcome#new",
        via: [:get, :post]

  match "welcome/select_action",
        to: "welcome#select_action",
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
  
  # Session test routes
  get "session_test/counter", to: "session_test#counter"
  post "session_test/increment", to: "session_test#increment"
  post "session_test/reset", to: "session_test#reset"
  
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
