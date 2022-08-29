# frozen_string_literal: true

module CheckJob
  extend ActiveSupport::Concern

  SORT_MESSAGES = %w[ruleId message line column].freeze

  def commit_reference(check)
    client = Octokit::Client.new
    repository = Repository.find(check.repository_id)
    repo = client.repo repository.full_name
    client.commits(repo.id)[0]['html_url']
  end

  def lint_language(check)
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

  def javascript_build(file, check)
    parsed_json = ActiveSupport::JSON.decode(file.chomp)

    report = parsed_json.map { |el| { filePath: el['filePath'], messages: el['messages'].map { |mes| mes.select { |k| SORT_MESSAGES.include?(k) } } } }.reject! { |el| el[:messages].empty? }

    issues_count = report.inject(0) { |count, el| count + el[:messages].size }

    check_update(check, issues_count, report)
  end

  def ruby_build(file, check)
    parsed_json = ActiveSupport::JSON.decode(file.chomp)
    issues_count = parsed_json['summary']['offense_count']

    report = parsed_json['files'].map do |el|
      {
        filePath: el['path'],
        messages: el['offenses']
          .map do |mes|
            mes['ruleId'] = mes['cop_name']
            mes.merge!(mes['location']).select! { |key| SORT_MESSAGES.include?(key) }
          end
      }
    end

    report.reject! { |el| el[:messages].empty? }

    check_update(check, issues_count, report)
  end

  def check_update(check, issues_count, report)
    params = {
      issues_count: issues_count,
      passed: issues_count.zero?,
      report: ActiveSupport::JSON.encode(report)
    }
    params[:reference] = commit_reference(check) if check.reference.nil?

    check.update(params)
  end
end
