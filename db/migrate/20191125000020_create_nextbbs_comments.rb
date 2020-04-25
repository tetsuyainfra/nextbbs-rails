class CreateNextbbsComments < ActiveRecord::Migration[6.0]
  def change
    create_table :nextbbs_comments do |t|
      t.references :topic, foreign_key: { to_table: :nextbbs_topics }
      t.string :name
      t.string :email
      t.text   :body
      t.string :hashid
      t.inet   :ip,                null: false
      t.string :hostname
      t.integer :status, limit: 1, null: false

      t.timestamps
    end

    # add_index :nextbbs_comments, [:topic_id, :created_at]
  end
end
