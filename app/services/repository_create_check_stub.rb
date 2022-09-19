# frozen_string_literal: true

require 'json'

class RepositoryCreateCheckStub
  def self.repos_clear; end

  def self.lint_language(check); end

  def self.commit_reference(_); end

  def self.show(_)
    [{ 'filePath' => 'tmp/repos/MehPNZ/masya/test/hexlet_code_test.rb',
       'messages' => [{ 'message' => 'Missing top-level documentation comment for `class HexletCodeTest`.',
                        'ruleId' => 'Style/Documentation', 'line' => 5, 'column' => 1 }, { 'message' => 'Prefer `assert_not_nil` over `refute_nil`.',
                                                                                           'ruleId' => 'Rails/RefuteMethods', 'line' => 7, 'column' => 5 }] }]
  end

  def self.check_job(check)
    RepositoryCheckJob.perform_now(check.id)
  end

  def self.decode_json(_file)
    []
  end

  def self.report(_parsed_json, _sort_messages)
    []
  end
end
