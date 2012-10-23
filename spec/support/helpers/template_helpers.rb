module Support
  module TemplateHelpers
    def stub_template(hash)
      @controller.view_paths.unshift(ActionView::FixtureResolver.new(hash))
    end
  end
end
