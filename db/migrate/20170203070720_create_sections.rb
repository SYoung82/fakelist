class CreateSections < ActiveRecord::Migration[5.0]
  def up
    create_table :sections do |t|
      t.string :name
    end
  end
end
