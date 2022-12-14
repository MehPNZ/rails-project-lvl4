# frozen_string_literal: true

require 'json'

class RepositoryCreateCheck
  def self.repos_clear
    Open3.capture2("rm -rf #{Rails.root.join('tmp/repos/')}")
  end

  def self.lint_language(check)
    repo_name = check.repository.full_name
    repo_path = "https://github.com/#{repo_name}"

    Open3.capture2("git clone #{repo_path} tmp/repos/#{repo_name}")

    case check.repository.language
    when 'javascript'
      Open3.capture2("rm #{Rails.root.join("tmp/repos/#{repo_name}/.eslintrc.yml")}")
      Open3.capture2("yarn run eslint --format json -o #{Rails.root.join("tmp/repos/#{repo_name}/javascript.json")} #{Rails.root.join("tmp/repos/#{repo_name}/")}")
      File.read(Rails.root.join("tmp/repos/#{repo_name}/javascript.json").to_s, encoding: 'utf-8')
    when 'ruby'
      Open3.capture2("rubocop --format json --out #{Rails.root.join("tmp/repos/#{repo_name}/rubocop.json")} #{Rails.root.join("tmp/repos/#{repo_name}/")}")
      File.read(Rails.root.join("tmp/repos/#{repo_name}/rubocop.json").to_s, encoding: 'utf-8')
    end
  end

  def self.commit_reference(check)
    client = Octokit::Client.new
    repository = Repository.find(check.repository_id)
    repo = client.repo repository.full_name
    client.commits(repo.id)[0]['html_url']
  end

  def self.show(check)
    ActiveSupport::JSON.decode(check.report)
  end

  def self.check_job(check)
    RepositoryCheckJob.perform_later(check.id)
  end

  def self.decode_json(file)
    ActiveSupport::JSON.decode(file.chomp)
  end

  def self.report(parsed_json, sort_messages)
    parsed_json.map { |el| { filePath: el['filePath'], messages: el['messages'].map { |mes| mes.select { |k| sort_messages.include?(k) } } } }.reject! { |el| el[:messages].empty? }
  end
end
