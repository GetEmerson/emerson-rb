module Support
  module TemplateHelpers
    def stub_template(hash)
      @controller.view_paths.unshift(ActionView::FixtureResolver.new(hash))
    end

    def templates(&block)
      klass  = Class.new(&block)
      inst   = klass.new
      config = {}.tap do |hash|
        inst.public_methods(false).each do |method|
          content = inst.send(method)
          hash["products/#{method}.html.erb"] = content.gsub(/^\s+/, '')
        end
      end

      stub_template(config)
    end

    def template(config)
      is_layout       = config.delete(:layout)
      suffix, content = config.flatten

      if is_layout
        stub_template("layouts/support/resource_helpers/#{suffix}" => content)
      else
        stub_template("support/resource_helpers/#{suffix}" => content)
      end
    end
  end
end
