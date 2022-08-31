# frozen_string_literal: true

require 'json'

class RepositoryCreateCheck
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
end
