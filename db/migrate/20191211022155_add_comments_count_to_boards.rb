class AddCommentsCountToBoards < ActiveRecord::Migration[6.0]
  def self.up
    add_column :nextbbs_boards, :comments_count, :integer, null: false, default: 0
  end

  def self.down
    remove_column :nextbbs_boards, :comments_count
  end
end
