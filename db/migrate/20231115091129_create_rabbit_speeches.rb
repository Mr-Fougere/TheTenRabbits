class CreateRabbitSpeeches < ActiveRecord::Migration[7.1]
  def change
    create_table :rabbit_speeches do |t|

      t.timestamps
    end
  end
end
