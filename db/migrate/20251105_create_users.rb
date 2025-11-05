class CreateUsers < ActiveRecord::Migration[7.0]
  def up
    drop_table :users, if_exists: true

    create_table :users do |t|
      t.string   :username,   null: false
      t.string   :nickname,   null: false
      t.string   :phone,      null: false
      t.string   :password,   null: false
      t.datetime :create_time, null: false
      t.integer  :status,     null: false, default: 1
    end

    add_index :users, :nickname, unique: true

    # 尝试在数据库层设置默认 CURRENT_TIMESTAMP（MySQL >= 5.6.5）。若不支持则忽略错误。
    begin
      execute "ALTER TABLE #{quote_table_name(:users)} MODIFY create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP"
    rescue => e
      Rails.logger.warn "Could not set DB default CURRENT_TIMESTAMP for create_time: #{e.message}"
    end
  end

  def down
    drop_table :users, if_exists: true
  end
end