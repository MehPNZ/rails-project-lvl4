class CreateRepositories < ActiveRecord::Migration[6.1]
  def change
    create_table :repositories do |t|
      t.string :link
      t.string :repo_name
      t.string :language
      t.datetime 'repo_created_at'
      t.datetime 'repo_updated_at'
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
