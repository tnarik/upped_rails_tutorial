class AddStatusToUsers < ActiveRecord::Migration
  def change
    add_column :users, :status, :integer, default: User.state_machines[:status].states[:inactive].value
    add_index  :users, :status

    User.reset_column_information
    User.all.each do |user|
      user.status_event = "activate"
      user.save
    end
  end

end
