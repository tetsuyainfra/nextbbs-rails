class CreateNextbbsTopics < ActiveRecord::Migration[6.0]
  def change
    create_table :nextbbs_topics do |t|
      t.string :title

      t.timestamps
    end
  end
end
