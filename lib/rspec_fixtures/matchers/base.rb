module RSpecFixtures
  module Matchers

    class Base
      attr_reader :fixture_name, :actual, :distance

      def initialize(fixture_name=nil)
        @fixture_name = fixture_name
      end

      def matches?(actual)
        @actual = actual
        false
      end

      def diff(distance)
        @distance = distance
        self
      end

      def expected
        @expected ||= expected!
      end

      def failure_message
        "expected #{actual}\nto match #{expected}"
      end

      def diffable?
        true
      end

      def interactive?
        RSpec.configuration.interactive_fixtures
      end

      def fixtures_dir
        RSpec.configuration.fixtures_path
      end

      def fixture_file
        "#{fixtures_dir}/#{fixture_name}"
      end
      
      protected

      def approve_fixture
        approval_handler = ApprovalHandler.new
        approval_handler.run expected, actual, fixture_file
      end

      def expected!
        File.exist?(fixture_file) ? File.read(fixture_file) : ''
      end
    end

  end
end
