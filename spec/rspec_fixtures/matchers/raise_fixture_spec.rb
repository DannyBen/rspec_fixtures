require 'spec_helper'

describe Matchers::RaiseFixture do
  subject { Matchers::RaiseFixture.new 'raised' }

  describe '::raise_fixture' do
    it "works" do
      expect{ raise "Something fakely went wrong" }.to raise_fixture('raised')
    end

    context "when the block does not raise anything" do
      it "uses compares with 'Nothing raised'" do
        expect{ puts "not raising" }.to raise_fixture('nothing-raised')
      end
    end

    context "when an error type is given" do
      it "works" do
        expect{ raise ArgumentError, "arrrrggg" }.to raise_fixture(ArgumentError, 'arg-error')
      end
    end
  end
end
