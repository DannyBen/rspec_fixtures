require 'spec_helper'

describe ApprovalHandler do
  let(:fixture) { 'spec/fixtures/approval_handler' }
  
  before do
    File.delete fixture if File.exist? fixture
  end

  describe '#run' do
    context "when the user answers y(es)" do
      before do
        expect(subject).to receive(:user_approves?).and_return true
      end

      it "writes actual result to fixture and reutrns true" do
        supress_output do
          expect(subject.run 'expected', 'actual', fixture).to be true
        end
        expect(File.read fixture).to eq 'actual'
      end

      context "when the fixture folders do not exist" do
        it "creates them using deep_write" do
          expect(File).to receive(:deep_write).with('some/deep/path', 'actual')
          supress_output do
            subject.run 'expected', 'actual', 'some/deep/path'
          end
        end
      end
    end

    context "when the user answers n(o)" do
      before do
        expect(subject).to receive(:user_approves?).and_return false
      end

      it "does not write to fixture and returns false" do
        supress_output do
          expect(subject.run 'expected', 'actual', fixture).to be false
        end
        expect(File).not_to exist fixture
      end      
    end
  end
end
