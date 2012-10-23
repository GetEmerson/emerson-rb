module Emerson # :nodoc:
  module Matchers
    module ActionController # :nodoc:
      # Example:
      #
      #   expect(response).to send_json({ :key => 'value' })
      #   expect(response).to send_json('path/to/fixture')
      #
      # Example fixture definitions:
      #
      #   # 'data-fixture.json'
      #   {
      #     "data" : {
      #       "user" : 1
      #     }
      #   }
      #
      #   # 'view-fixture.json'
      #   {
      #     "view" : "<article class=\"user\"></article>"
      #   }
      #
      #   # 'full-fixture.json' (will merge data & view)
      #   {
      #     "$extends" : ["data-fixture.json", "view-fixture.json"]
      #   }
      def send_json(expected)
        SendJsonMatcher.new(expected, self)
      end

      class SendJsonMatcher # :nodoc:
        attr_reader :expected, :actual, :mode

        def initialize(expected, context)
          @context  = context
          @expected = prepare(expected)
        end

        def description
          ['send JSON:', @mode_description].join(' ')
        end

        def matches?(response)
          @actual = JSON.parse(response.body)
          actual == expected
        end

        def failure_message
          msg = <<-MSG
            Expected actual response:
            #{'-' * 60}
            #{JSON.pretty_generate(actual)}
            to match:
            #{'-' * 60}
            #{JSON.pretty_generate(expected)}
          MSG

          msg.gsub(/^\s{12}/, '')
        end

        private

          def filename(name)
            "#{name.sub(/\.json\z/, '')}.json"
          end

          def fixture(name)
            File.join(fixture_path, filename(name))
          end

          # TODO: allow Test::Unit definition
          def fixture_path
            # @_fixture_path ||= "#{Emerson.fixture_path || RSpec.configuration.fixture_path}/responses"
            @_fixture_path ||= File.join(Emerson.fixture_path, 'responses')
          end

          def prepare(source)
            result = begin
              case source
              when String
                @mode_description = filename(source)
                path = fixture(source)
                File.exist?(path) ? JSON.parse(File.read(path)) : { :missing => path.to_s }
              when Array, Hash
                @mode_description = '(provided)'
                JSON.parse(source.to_json)
              else
                raise ArgumentError.new('expected "JSON" should be a Hash, or a String lookup')
              end
            end

            if result.is_a?(Hash) && result.keys.include?('$extends')
              refs = [result.delete('$extends')].flatten

              result = {}.tap do |hash|
                refs.each { |ref| hash.merge!(prepare(ref)) }
                hash.merge!(result)
              end
            end

            result
          end
      end
    end
  end
end
