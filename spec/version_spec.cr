require "./spec_helper"

module X
  describe VERSION do
    it "has a version" do
      X::VERSION.should_not be_nil
    end

    it "has a major version" do
      X::VERSION.major.should_not be_nil
    end

    it "has a minor version" do
      X::VERSION.minor.should_not be_nil
    end

    it "has a patch version" do
      X::VERSION.patch.should_not be_nil
    end

    it "converts to a string" do
      X::VERSION.to_s.should be_a(String)
    end
  end
end
