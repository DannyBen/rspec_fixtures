require 'io/console'
require 'colsole'
require 'tty-prompt'
require 'diffy'

module RSpecApprovals

  # Handles user input and interactive approvals
  class ApprovalHandler
    include Colsole

    attr_reader :expected, :actual, :approval_file

    def run(expected, actual, approval_file)
      @expected = expected
      @actual = actual
      @approval_file = approval_file

      show expected.empty? ? actual : diff
      prompt_user
    end

    private

    def prompt_user
      response = auto_approve? ? :approve : get_response

      case response

      when :approve, :reject
        send response

      when :actual, :expected, :diff
        show send response
        prompt_user

      else
        false

      end
    end

    def auto_approve?
      RSpec.configuration.auto_approve
    end

    def get_response
      prompt.select "Please Choose:", menu_options, symbols: { marker: '>' }
    rescue TTY::Reader::InputInterrupt
      # :nocov:
      return :reject
      # :nocov:
    end

    def menu_options
      base = {
        'Reject (and fail test)' => :reject,
        'Approve (and save)' => :approve,
      }

      extra = {
        'Show actual output' => :actual,
        'Show expected output' => :expected,
        'Show diff' => :diff,
      }

      expected.empty? ? base : base.merge(extra) 
    end

    def approve
      say "!txtgrn!Approved"
      File.deep_write approval_file, actual
      true
    end

    def reject
      say "!txtred!Not Approved"
      false
    end

    def separator
      "!txtgrn!" + ('_' * terminal_width)
    end

    def diff
      Diffy::Diff.new(expected, actual, context: 2).to_s :color
    end

    def show(what)
      say separator
      say what
      say separator
    end

    def prompt
      @prompt ||= TTY::Prompt.new
    end
  end
end