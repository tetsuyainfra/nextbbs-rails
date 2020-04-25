class CreateNextbbsTopics < ActiveRecord::Migration[6.0]
  def change
    create_table :nextbbs_topics do |t|
      t.references :board, foreign_key:  { to_table: :nextbbs_boards }
      t.string     :title
      t.integer :status, limit: 1, null: false

      t.timestamps
    end

    # add_index :nextbbs_topics, [:board_id, :created_at]
  end
end
