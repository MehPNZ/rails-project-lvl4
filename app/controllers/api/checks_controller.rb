class Api::ChecksController < ActionController::Base
  protect_from_forgery with: :null_session

  def create
    return if params['head_commit'].nil?

    @repository = Repository.find_by(full_name: params['repository']['full_name'])
    @check = @repository&.checks&.build(reference: params['head_commit']['url'])
    @check.save
    RepositoryCheckJob.perform_later(@check.id)
  end
end
