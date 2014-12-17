class AddcolumnstoShipment < ActiveRecord::Migration
  def change
    add_column :shipments, :city, :string
    add_column :shipments, :state, :string
    add_column :shipments, :postal_code, :string
    add_column :shipments, :weight, :float
  end
end
