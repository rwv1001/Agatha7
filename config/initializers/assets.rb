# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = "1.0"

Rails.application.config.assets.precompile += %w( display_format.js )
Rails.application.config.assets.precompile += %w( edit.js )
Rails.application.config.assets.precompile += %w( group_filters.js )
Rails.application.config.assets.precompile += %w( search_ctl.js )

Rails.application.config.assets.precompile += %w( template.js )
Rails.application.config.assets.precompile += %w( prepend_template.js )
Rails.application.config.assets.precompile += %w( controllers/hello_controller.js )
Rails.application.config.assets.precompile += %w( controllers/index.js )
Rails.application.config.assets.precompile += %w( controllers/application.js )

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in the app/assets
# folder are already added.
# Rails.application.config.assets.precompile += %w[ admin.js admin.css ]
