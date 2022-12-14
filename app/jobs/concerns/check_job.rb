# frozen_string_literal: true

module CheckJob
  extend ActiveSupport::Concern

  SORT_MESSAGES = %w[ruleId message line column].freeze

  def javascript_build(file, check)
    repository_check = ApplicationContainer[:repository_check]
    parsed_json = repository_check.decode_json(file)

    report = repository_check.report(parsed_json, SORT_MESSAGES)

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
    repository_check = ApplicationContainer[:repository_check]
    params = {
      issues_count: issues_count,
      passed: issues_count.zero?,
      report: ActiveSupport::JSON.encode(report)
    }
    params[:reference] = repository_check.commit_reference(check) if check.reference.nil?

    check.update(params)
  end

  def repo_check(check)
    check_build(check)

    repository_check.repos_clear

    UserMailer.with(check: check).check_email.deliver_now unless check.passed
  rescue StandardError
    check&.to_fail! if check&.may_to_fail?
    UserMailer.with(check: check).check_email.deliver_now
    repository_check.repos_clear
  end

  private

  def check_build(check)
    check.to_check! if check.may_to_check?

    file = repository_check.lint_language(check)

    send("#{check.repository.language}_build", file, check)

    check.to_finish! if check.may_to_finish?
  end

  def repository_check
    ApplicationContainer[:repository_check]
  end
end
