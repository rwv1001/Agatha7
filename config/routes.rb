Rails.application.routes.draw do
  # Handle Chrome DevTools requests gracefully
  get "/.well-known/appspecific/com.chrome.devtools.json", to: proc { |env| [204, {}, [""]] }

  # ActionCable mount
  mount ActionCable.server => "/cable"

  # Home page
  root to: "welcome#index"

  # Admin login/logout
  get "admin/login", to: "admin#login"
  post "admin/login", to: "admin#login"
  get "admin/logout", to: "admin#logout"
  post "admin/logout", to: "admin#logout"

  # Welcome custom actions
  match "welcome/table_search",
    to: "welcome#table_search",
    via: [:get, :post]

  match "welcome/order_toggle",
    to: "welcome#order_toggle",
    via: [:get, :post]

  match "welcome/delete_column",
    to: "welcome#delete_column",
    via: [:get, :post],
    as: "welcome_delete_column"

  match "welcome/add_external_filter",
    to: "welcome#add_external_filter",
    via: [:get, :post]

  match "welcome/update_external_filter",
    to: "welcome#update_external_filter",
    via: [:get, :post]

  match "welcome/refresh_external_filter",
    to: "welcome#refresh_external_filter",
    via: [:get, :post]

  match "welcome/refresh_edit_select",
    to: "welcome#refresh_edit_select",
    via: [:get, :post]

  match "welcome/refresh_external_filter_select",
    to: "welcome#refresh_external_filter_select",
    via: [:get, :post]

  match "welcome/get_object_display_name",
    to: "welcome#get_object_display_name",
    via: [:get, :post]

  match "welcome/fetch_updated_rows",
    to: "welcome#fetch_updated_rows",
    via: [:get, :post]

  match "welcome/update_group_filters",
    to: "welcome#update_group_filters",
    via: [:get, :post]

  match "welcome/make_suggestion",
    to: "welcome#make_suggestion",
    via: [:get, :post]

  match "welcome/update_formats",
    to: "welcome#update_formats",
    via: [:get, :post]

  get "welcome/fetch_updated_rows", to: "welcome#fetch_updated_rows"

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

  match "welcome/delete",
    to: "welcome#delete",
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
  get "manifest" => "rails/pwa#manifest", :as => :pwa_manifest

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
        get :export_excel
      end

      # Add custom member actions for users
      if resource == "users"
        member do
          post :admin_update_user
          post :update_user
        end
        collection do
          post :new_user
          post :admin_update_user  # Allow admin_update_user without ID in URL
        end
      end
    end
  end

  # Catch-all route for unmatched URLs - must be last!
  match "*path", to: "application#render_404", via: :all
end
