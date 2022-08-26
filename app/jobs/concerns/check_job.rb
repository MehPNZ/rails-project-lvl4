module CheckJob
  extend ActiveSupport::Concern
  
  SORT_MESSAGES = ['ruleId', 'message', 'line' , 'column']

  def commit_reference(check)
    client = Octokit::Client.new
    repository = Repository.find(check.repository_id)
    repo = client.repo repository.link
    client.commits(repo.id)[0]['html_url']
  end

  def lint_language(check)
    repo_name = check.repository.link
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
    # report = parsed_json.each_with_object([]) do |el, item|
    #   item << el.select do |key, _value|
    #     key == 'filePath' || (key == 'messages' && !el['messages'].empty?)
    #   end
    # end

    # report.reject! { |el| !el.key?('messages') }.each{|el| el['messages'].each{|el| el.select!{|k, v| SORT_MESSAGES.include?(k)}}}
    report = parsed_json.map{|el| { filePath: el['filePath'], 
                                    messages: el['messages'].map{|mes| mes.select{|k| SORT_MESSAGES.include?(k)}}}}
                            .select!{|el| !el[:messages].empty?}

    issues_count = report.inject(0) { |count, el| count += el[:messages].size }
    check_update(check, issues_count, report)
  end

  def ruby_build(file, check)
    parsed_json = ActiveSupport::JSON.decode(file.chomp)
    issues_count = parsed_json['summary']['offense_count']
    
    #  debugger
    # report = parsed_json['files'].each_with_object([]) do |el, item|
    #   item << {
    #     'filePath': el.fetch('path'),
    #     'messages': el.fetch('offenses').
    #       each do |v| 
    #         v['ruleId'] = v.fetch('cop_name')
    #         v.merge!(v['location']).select!{|key| SORT_MESSAGES.include?(key)}
    #       end
    #     }
    #   end
      
    #   report.select!{|el| !el[:messages].empty?}


      report = parsed_json['files'].map{|el|
          {
            filePath: el['path'],
            messages: el['offenses'].
              map do |mes|
                mes['ruleId'] = mes['cop_name']
                mes.merge!(mes['location']).select!{|key| SORT_MESSAGES.include?(key)}
              end
          }
        }

      report.select!{|el| !el[:messages].empty?}

      check_update(check, issues_count, report)
  end

  def check_update(check, issues_count, report)

    params = {
      issues_count: issues_count,
      check_passed: issues_count == 0,
      report: ActiveSupport::JSON.encode(report)
    }
    params[:reference] = commit_reference(check) if check.reference.nil?

    check.update(params)
  end
end
