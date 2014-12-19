class CreateLogs < ActiveRecord::Migration
  def change
    create_table :logs do |t|
      t.string :url
      t.string :ip_address
      t.json :params
      t.json :response

      t.timestamps
    end
  end
end
