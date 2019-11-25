class CreateNextbbsComments < ActiveRecord::Migration[6.0]
  def change
    create_table :nextbbs_comments do |t|
      t.string :name
      t.text :body
      t.integer :topic_id, null: false

      t.timestamps
    end

    add_foreign_key :nextbbs_comments, :nextbbs_topics, column: :topic_id
  end
end
