class CreateNextbbsBoards < ActiveRecord::Migration[6.0]
  def change
    create_table :nextbbs_boards do |t|
      t.string :name
      t.string :title
      t.text   :description
      t.string :hash_token
      t.integer :status, limit: 1, null: false

      t.timestamps
    end
  end
end
