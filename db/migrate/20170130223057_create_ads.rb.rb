class CreateAds < ActiveRecord::Migration[5.0]
  def up
    create_table :ads do |t|
      t.string :title
      t.string :content
      t.integer :user_id
    end
  end

  def down
    drop_table :ads
  end
end
