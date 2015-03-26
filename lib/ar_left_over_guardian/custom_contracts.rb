require "contracts/noop"

Contracts::Noop.when_contracts_available do
  puts "Running with contracts in development mode"
end

module ARLeftOverGuardian
  module CustomContracts
    include Contracts

    Model = RespondTo[:count]
  end
end
