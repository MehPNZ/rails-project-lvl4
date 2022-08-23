class Api::ChecksController < ActionController::Base
  protect_from_forgery with: :null_session

  def create
    return if params['head_commit'].nil?

    @repository = Repository.find_by(link: params['repository']['full_name'])
    @check = @repository&.checks&.build(reference: params['head_commit']['url'])
    @check.save
    RepositoryCheckJob.perform_async(@check.id)
  end
end