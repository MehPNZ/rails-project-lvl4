# frozen_string_literal: true

class CreateRepositoryChecks < ActiveRecord::Migration[6.1]
  def change
    create_table :repository_checks do |t|
      t.string :aasm_state
      t.string :repository
      t.boolean :passed
      t.integer :issues_count
      t.text :report
      t.string :reference
      t.references :repository, null: true, foreign_key: true

      t.timestamps null: true
    end
  end
end
