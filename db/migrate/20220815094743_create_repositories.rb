class CreateRepositories < ActiveRecord::Migration[6.1]
  def change
    create_table :repositories do |t|
      t.string :full_name
      t.string :name
      t.string :language
      t.integer :github_id
      t.datetime 'repo_created_at'
      t.datetime 'repo_updated_at'
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
