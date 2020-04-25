class AddCommentsCountToTopics < ActiveRecord::Migration[6.0]
  def change
    add_column :nextbbs_topics, :comments_count, :integer, null: false, default: 0
  end
end
