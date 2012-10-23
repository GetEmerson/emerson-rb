Rails.application.config.assets.paths << Emerson::Engine.root.join('spec/javascripts')
Rails.application.config.assets.paths << Emerson::Engine.root.join('spec/stylesheets')
ActionController::Base.prepend_view_path Emerson::Engine.root
