require 'spec_helper'

describe MotherBrain::Chef::Config do
  subject(:chef_config) { described_class.new(path) }

  let(:path) { nil }
  let(:file_contents) {
    <<-CHEF_CONFIG
      user "root"
      pass "secret"
      mode :none
      var = 123
      interpolated "\#{var}"
    CHEF_CONFIG
  }

  before do
    chef_config.stub(
      file_contents: file_contents
    )
  end

  describe "#parse" do
    before { chef_config.parse }

    it "parses each line and creates a key in the hash" do
      expect(chef_config[:user]).to eq("root")
      expect(chef_config[:pass]).to eq("secret")
      expect(chef_config[:mode]).to eq(:none)
    end

    it "parses local variables that can be used on other lines" do
      expect(chef_config[:variable]).to be_nil
      expect(chef_config[:interpolated]).to eq("123")
    end
  end
end
