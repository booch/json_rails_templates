# TODO: Add ActionView (or Tilt) as a gem dependency.
require 'action_view'


if defined?(::ActionView)
  class JsonRailsTemplateHandler
    def self.call(template)
      new.call(template)
    end

    def call(template)
      "'" + JsonRailsTemplates.new(template.source).to_json + "'"
    end
  end

  ::ActionView::Template.register_template_handler :json, JsonRailsTemplateHandler
end
