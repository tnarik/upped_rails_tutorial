class AddStatusToUsers < ActiveRecord::Migration
  def change
    add_column :users, :status, :integer
    add_index  :users, :status

    User.reset_column_information
    User.all.each do |user|
      user.status = User.state_machines[:status].states[:active].value
      user.save(:validate => false)
    end
  end

end
