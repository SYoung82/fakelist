class AddSectionToAds < ActiveRecord::Migration[5.0]
  def change
    add_column :ads, :section_id, :integer
  end
end
