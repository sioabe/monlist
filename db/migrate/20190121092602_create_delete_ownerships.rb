class CreateDeleteOwnerships < ActiveRecord::Migration[5.0]
  def change
   drop_table :ownerships
  end
end
