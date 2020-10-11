class CreateNextbbsModels < ActiveRecord::Migration[6.0]
  def change
    create_table :nextbbs_boards do |t|
      t.bigint :owner_id, null: false
      t.string :name
      t.string :title
      t.text :description
      t.string :hash_token
      t.integer :status, limit: 1, null: false

      t.timestamps
    end
    add_column :nextbbs_boards, :comments_count, :integer, null: false, default: 0

    create_table :nextbbs_topics do |t|
      t.bigint :owner_id, null: false
      t.references :board, foreign_key: { to_table: :nextbbs_boards }
      t.string :title
      t.integer :status, limit: 1, null: false

      t.timestamps
    end
    add_column :nextbbs_topics, :comments_count, :integer, null: false, default: 0
    # add_index :nextbbs_topics, [:board_id, :created_at]

    create_table :nextbbs_comments do |t|
      t.bigint :owner_id, null: true
      t.integer :sequential_id
      t.references :topic, foreign_key: { to_table: :nextbbs_topics }
      t.string :name
      t.string :email
      t.text :body
      t.string :hashid
      t.inet :ip, null: false
      t.string :hostname
      t.integer :status, limit: 1, null: false

      t.timestamps
    end
    # add_index :nextbbs_comments, [:topic_id, :created_at]

    # # Board must have Owner(User)
    # add_column :nextbbs_boards, :owner_id, :bigint, index: true, null: false
    # add_foreign_key :nextbbs_boards, :users, column: :owner_id

    # # Comment have nullable User(Guest)
    # add_column :nextbbs_comments, :owner_id, :bigint, index: true
  end
end
