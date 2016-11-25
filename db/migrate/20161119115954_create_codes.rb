class CreateCodes < ActiveRecord::Migration[5.0]
  def change
    create_table :codes do |t|
      t.text :source_code
      t.string :unique_link
      t.datetime :datetime_of_creation

      t.timestamps
    end
  end
end
