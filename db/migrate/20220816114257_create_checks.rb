class CreateChecks < ActiveRecord::Migration[6.1]
  def change
    create_table :checks do |t|
      t.string :status
      t.boolean :check_passed
      t.integer :issues_count
      t.text :report
      t.string :reference
      t.references :repository, null: false, foreign_key: true

      t.timestamps
    end
  end
end
