class AddForeignKeyToNextbbsBoardsAndComments < ActiveRecord::Migration[6.0]
  def change
    # Board must have Owner(User)
    add_column :nextbbs_boards, :owner_id, :bigint, index: true, null: false
    add_foreign_key :nextbbs_boards, :users, column: :owner_id

    # Comment have nullable User(Guest)
    add_column :nextbbs_comments, :owner_id, :bigint, index: true
  end
end
