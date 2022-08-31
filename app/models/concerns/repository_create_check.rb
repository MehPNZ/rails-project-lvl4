# frozen_string_literal: true

require 'json'

class RepositoryCreateCheckStub
  def self.repos_clear
  end

  def self.lint_language(check)
    repo_name = check.repository.full_name
    repo_path = "https://github.com/#{repo_name}"

    Open3.capture2("git clone #{repo_path} tmp/repos/#{repo_name}")

    case check.repository.language
    when 'javascript'
      Open3.capture2("rm #{Rails.root}/tmp/repos/#{repo_name}/.eslintrc.yml")
      Open3.capture2("yarn run eslint --format json -o #{Rails.root}/tmp/repos/#{repo_name}/javascript.json #{Rails.root}/tmp/repos/#{repo_name}/")
      File.read("#{Rails.root}/tmp/repos/#{repo_name}/javascript.json", encoding: 'utf-8')
    when 'ruby'
      Open3.capture2("rubocop --format json --out #{Rails.root}/tmp/repos/#{repo_name}/rubocop.json #{Rails.root}/tmp/repos/#{repo_name}/")
      File.read("#{Rails.root}/tmp/repos/#{repo_name}/rubocop.json", encoding: 'utf-8')
    end
  end

  def self.commit_reference(check)
    client = Octokit::Client.new
    repository = Repository.find(check.repository_id)
    repo = client.repo repository.full_name
    client.commits(repo.id)[0]['html_url']
  end
end
