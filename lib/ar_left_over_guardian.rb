require "ar_left_over_guardian/version"

module ARLeftOverGuardian
  def self.init(models)
    Instance.new(models)
  end

  class DidntCleanup < StandardError; end

  class Instance
    def initialize(models)
      @models = models.reject(&method(:abstract?))
      @counts = current_counts(false)
    end

    def verify
      left_overs = get_left_overs
      return if left_overs.empty?
      model_list = left_overs.map { |model| "- #{model}" }.join("\n")
      raise DidntCleanup.new("Following models has left over records:\n#{model_list}")
    end

    private

    attr_reader :counts, :models

    def get_left_overs
      current_counts.each_with_index.inject([]) do |acc, (count, index)|
        if count != counts[index]
          acc << models[index]
        end
        acc
      end
    end

    def current_counts(reset = true)
      models.map { |model|
        reset_model(model, reset).count
      }
    end

    def abstract?(model)
      model.respond_to?(:abstract_class?) && model.abstract_class?
    end

    def reset_model(model, reset)
      return model unless reset
      RSpec::Mocks.space.proxy_for(model).reset if defined?(RSpec::Mocks)
      model
    end
  end
end
