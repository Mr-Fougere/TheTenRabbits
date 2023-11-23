class AddRabbitVoteToSession < ActiveRecord::Migration[7.1]
  def change
    add_reference :sessions, :voted_rabbit, foreign_key: { to_table: :rabbits }, null: true
  end
end
