class SetPersonalEmailNotNull < ActiveRecord::Migration[8.0]
  def change
    change_column_null :users, :personal_email, false
  end
end
