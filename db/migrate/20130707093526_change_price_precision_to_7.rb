class ChangePricePrecisionTo7 < ActiveRecord::Migration
  def change
    change_column :products, :price, :decimal, precision: 7
  end
end
