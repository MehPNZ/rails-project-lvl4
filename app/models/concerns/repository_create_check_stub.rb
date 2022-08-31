# frozen_string_literal: true

require 'json'

class RepositoryCreateCheckStub
  def self.repos_clear; end

  def self.lint_language(check)
    case check.repository.language
    when 'javascript'
      Open3.capture2("yarn run eslint --format json -o #{Rails.root}/test/fixtures/files/javascript.json #{Rails.root}/test/fixtures/files/javascript.js")
      File.read("#{Rails.root}/test/fixtures/files/javascript.json", encoding: 'utf-8')
    when 'ruby'
      Open3.capture2("rubocop --format json --out #{Rails.root}/test/fixtures/files/rubocop.json #{Rails.root}/test/fixtures/files/ruby.rb")
      File.read("#{Rails.root}/test/fixtures/files/rubocop.json", encoding: 'utf-8')
    end
  end

  def self.commit_reference(check)
    # client = Octokit::Client.new
    # repository = Repository.find(check.repository_id)
    # repo = client.repo repository.full_name
    # client.commits(repo.id)[0]['html_url']
  end

  def self.show(_)
    # report = File.read('test/fixtures/files/report.txt')
    # result = ActiveSupport::JSON.decode(report)
    # result
    [{"filePath"=>"tmp/repos/MehPNZ/masya/test/hexlet_code_test.rb", 
      "messages"=>[{"message"=>"Missing top-level documentation comment for `class HexletCodeTest`.", 
      "ruleId"=>"Style/Documentation", "line"=>5, "column"=>1}, {"message"=>"Prefer `assert_not_nil` over `refute_nil`.", 
      "ruleId"=>"Rails/RefuteMethods", "line"=>7, "column"=>5}]}]
  end
end
