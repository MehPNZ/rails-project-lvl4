require "octokit"

class RepositoryLoaderJob < ApplicationJob
  queue_as :default
  # include Sidekiq::Job

  def perform(id, token)
    client = Octokit::Client.new access_token: token, auto_paginate: true
    repository = Repository.find(id)

    repo = client.repo repository.link

    params = {
      repo_name: repo.name,
      language: repo.language.downcase,
      repo_created_at: repo.created_at,
      repo_updated_at: repo.updated_at
    }

    repository.update(params)
    # client.add_repository_to_app_installation(228494, repo.id)

    # Open3.capture2("curl -H \"Authorization: token #{token}\" https://api.github.com/user")

    client.create_hook( repo.full_name, 'web', { url:  ENV['BASE_URL'], content_type: 'json' }, {events: ['push'], active: true, insecure_ssl: 0})
  end
end

#app_id = 228494
# curl -X DELETE -H "Accept: application/vnd.github+json" -H "Authorization: token ghu_XjLWDp1Evrxltm9TSby4hhrNs2RsGW0Nl1z3" https://api.github.com/user/installations/228494/repositories/502905064

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

# # curl \ -X POST \ -H "Accept: application/vnd.github+json" \ -H "Authorization: token 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" \ https://api.github.com/repos/MehPNZ/ruby-gems/hooks \ -d '{"name":"web","active":true,"events":["push","pull_request"],"config":{"url":"https://example.com/webhook","content_type":"json","insecure_ssl":"0"}}'

# curl -H "Authorization: token ghu_sEo2vLhfg6CjN0BvhhgRQugxPkSCKi1032ki" https://api.github.com/user
# curl -X POST -H "Accept: application/vnd.github+json" -H "Authorization: token ghu_sEo2vLhfg6CjN0BvhhgRQugxPkSCKi1032ki" https://api.github.com/repos/MehPNZ/ruby-gems/hooks -d '{"name":"web","active":true,"events":["push","pull_request"],"config":{"url":"https://example.com/webhook","content_type":"json","insecure_ssl":"0"}}' 
