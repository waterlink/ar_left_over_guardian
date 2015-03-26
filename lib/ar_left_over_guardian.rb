require "ar_left_over_guardian/version"
require "ar_left_over_guardian/custom_contracts"

# Fails your test suite if tests doesn't clean up any database records
# after itself. Assumes models have `.count` method.
module ARLeftOverGuardian
  include Contracts
  include CustomContracts

  class DidntCleanup < StandardError; end

  # Instance of left over guardian, which keeps track of all models
  # counts before test and after test, and expects them to be the same
  class Instance
    include Contracts
    include CustomContracts

    # Creates new instance
    Contract ArrayOf[Model] => self
    def initialize(models)
      @models = models.reject(&method(:abstract?))
      @counts = current_counts(false)
      self
    end

    # Verifies if counts before test and after are the same.
    # @raise [DidntCleanup] When counts don't match
    Contract None => nil
    def verify
      left_overs = get_left_overs
      return if left_overs.empty?
      model_list = left_overs.map { |model| "- #{model}" }.join("\n")
      raise DidntCleanup.new("Following models has left over records:\n#{model_list}")
    end

    private

    attr_reader :counts, :models

    Contract None => ArrayOf[Model]
    def get_left_overs
      current_counts.each_with_index.inject([]) do |acc, (count, index)|
        if count != counts[index]
          acc << models[index]
        end
        acc
      end
    end

    Contract Bool => ArrayOf[Num]
    def current_counts(reset = true)
      models.map { |model|
        reset_model(model, reset).count
      }
    end

    Contract Model => Bool
    def abstract?(model)
      model.respond_to?(:abstract_class?) && model.abstract_class?
    end

    Contract Model, Bool => Model
    def reset_model(model, reset)
      return model unless reset
      RSpec::Mocks.space.proxy_for(model).reset if defined?(RSpec::Mocks)
      model
    end
  end

  # Initializes instance of left over guardian with given list of
  # models
  Contract ArrayOf[Model] => Instance
  def self.init(models)
    Instance.new(models)
  end
end
