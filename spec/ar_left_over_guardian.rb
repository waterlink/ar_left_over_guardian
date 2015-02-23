class FakeModel < ActiveRecord::Base; end
class OtherFakeModel < ActiveRecord::Base; end

RSpec.describe ARLeftOverGuardian do
  describe ".init" do
    it "returns new instance of guardian" do
      expect(ARLeftOverGuardian.init).to be_a(ARLeftOverGuardian::Instance)
    end
  end
end

RSpec.describe ARLeftOverGuardian::Instance do
  def fake_count(count, opts={})
    on = opts.fetch(opts)
    allow(on).to receive(:count).and_return(count)
  end

  describe "#verify" do
    it "doesn't fail if counts are the same as before" do
      fake_count(5, on: FakeModel)
      fake_count(1, on: OtherFakeModel)

      instance = ARLeftOverGuardian.init

      expect { instance.verify }.not_to raise_error
    end

    it "fails if counts are different" do
      fake_count(5, on: FakeModel)
      fake_count(1, on: OtherFakeModel)

      instance = ARLeftOverGuardian.init

      fake_count(7, on: FakeModel)

      expect { instance.verify }.to raise_error(ARLeftOverGuardian::DidntCleanup, /- FakeModel/)
    end
  end
end
