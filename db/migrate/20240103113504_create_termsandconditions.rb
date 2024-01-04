class CreateTermsandconditions < ActiveRecord::Migration[7.0]
  def change
    create_table :termsandconditions do |t|
      t.string :name

      t.timestamps
    end
  end
end
