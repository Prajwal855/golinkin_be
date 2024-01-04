class CreateJobs < ActiveRecord::Migration[7.0]
  def change
    create_table :jobs do |t|
      t.string :position
      t.string :experience
      t.float  :salary
      t.string :skills_required
      t.string :small_description
      t.timestamps
    end
  end
end
