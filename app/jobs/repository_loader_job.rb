require "octokit"

class RepositoryLoaderJob
  include Sidekiq::Job

  def perform(id)
    client = Octokit::Client.new access_token: ENV['GITHUB_TOKEN'], auto_paginate: true
    repository = Repository.find(id)

    repo = client.repo repository.link

    params = {
      repo_name: repo.name,
      language: repo.language.downcase,
      repo_created_at: repo.created_at,
      repo_updated_at: repo.updated_at
    }
    # callback_url = ENV['BASE_URL']
    # client.subscribe("https://github.com/#{repo.full_name}/events/push.json", callback_url)
    repository.update(params)
    client.create_hook( repo.full_name, 'web', { url:  ENV['BASE_URL'], content_type: 'json' }, {events: ['push'], active: true, insecure_ssl: 0})
  end
end


# # def hook_create(client)
# #   client.create_hook( repo.full_name, 'web', { url:  ENV['BASE_URL'], content_type: 'json' }, {events: ['push'], active: true, insecure_ssl: '0'})
# #   end

# repository = Repository.find(id)

# repo = client.repo repository.link

# client.create_hook(repo.full_name, 'web', 
#                     { url:  ENV['BASE_URL'], 
#                       content_type: 'json' }, 
#                     { events: ['push'], 
#                       active: true, 
#                       insecure_ssl: '0'
#                     })

# client.subscribe "https://github.com/#{repo.full_name}/events/push.json", ENV['BASE_URL']

# curl \ -X POST \ -H "Accept: application/vnd.github+json" \ -H "Authorization: token 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" \ https://api.github.com/repos/MehPNZ/ruby-gems/hooks \ -d '{"name":"web","active":true,"events":["push","pull_request"],"config":{"url":"https://example.com/webhook","content_type":"json","insecure_ssl":"0"}}'
#  curl -X POST -H "Accept: application/vnd.github+json" -H "Authorization: token ghu_2dWdcfmoC20JcVOWac9YG4z9HgdTCr1bvdxP" https://api.github.com/repos/MehPNZ/ruby-gems/hooks -d '{"name":"web","active":true,"events":["push","pull_request"],"config":{"url":"https://example.com/webhook","content_type":"json","insecure_ssl":"0"}}' 
