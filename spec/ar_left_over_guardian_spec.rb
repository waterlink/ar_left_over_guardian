class FakeWithCount
  class << self
    attr_writer :count
    attr_accessor :abstract_class
    alias_method :abstract_class?, :abstract_class

    def count
      return @count if @count
      raise NotImplementedError.new("You should fake count out")
    end
  end

  self.abstract_class = true
end

class FakeModel < FakeWithCount; self.abstract_class = false; end
class OtherFakeModel < FakeWithCount; self.abstract_class = false; end

MODELS = [FakeWithCount, FakeModel, OtherFakeModel]

module CountFaker
  def fake_count(count, opts={})
    on = opts.fetch(:on)
    on.count = count
  end
end

RSpec.describe ARLeftOverGuardian do
  include CountFaker

  describe ".init" do
    it "returns new instance of guardian" do
      fake_count(0, on: FakeModel)
      fake_count(3, on: OtherFakeModel)
      expect(ARLeftOverGuardian.init(MODELS)).to be_a(ARLeftOverGuardian::Instance)
    end
  end
end

RSpec.describe ARLeftOverGuardian::Instance do
  include CountFaker

  describe "#verify" do
    it "doesn't fail if counts are the same as before" do
      fake_count(5, on: FakeModel)
      fake_count(1, on: OtherFakeModel)

      instance = ARLeftOverGuardian.init(MODELS)

      expect { instance.verify }.not_to raise_error
    end

    it "fails if counts are different" do
      fake_count(5, on: FakeModel)
      fake_count(1, on: OtherFakeModel)

      instance = ARLeftOverGuardian.init(MODELS)

      fake_count(7, on: FakeModel)

      expect { instance.verify }.to raise_error(ARLeftOverGuardian::DidntCleanup, /- FakeModel/)
    end
  end
end
