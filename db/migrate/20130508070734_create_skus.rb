class CreateSkus < ActiveRecord::Migration
  def change
    create_table :skus do |t|
      t.string :code

      t.timestamps
    end
  end
end
