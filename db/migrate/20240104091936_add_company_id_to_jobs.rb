class AddCompanyIdToJobs < ActiveRecord::Migration[7.0]
  def change
    add_reference :jobs, :company, null: false, foreign_key: true
  end
end
