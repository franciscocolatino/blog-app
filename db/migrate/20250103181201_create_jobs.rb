class CreateJobs < ActiveRecord::Migration[7.0]
  def change
    create_table :jobs, id: :uuid do |t|
      t.json :content, default: {}
      t.json :arguments, default: {}
      t.integer :progress, default: 0
      t.text :job_errors, array: true, default: []
      t.string :parentable_type
      t.string :status, default: 'pending'
      t.references :author, foreign_key: { to_table: :users }, type: :uuid

      t.timestamps
    end
  end
end
