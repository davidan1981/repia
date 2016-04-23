class CreateUniqueModels < ActiveRecord::Migration
  def change
    create_table :unique_models, id: false do |t|
      t.string :uuid, primary_key: true, null: false
      t.timestamps null: false
    end
  end
end
