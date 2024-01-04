class CreateCompanies < ActiveRecord::Migration[7.0]
  def change
    create_table :companies do |t|
      t.string :name
      t.string :company_type
      t.string :size
      t.string :website
      t.string :founded
      t.string :headquarters
      t.string :specialities
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
