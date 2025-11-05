class CreateFiles < ActiveRecord::Migration[7.0]
  def up
    create_table :files do |t|
      t.bigint   :user_id,    null: false
      t.string   :file_name,  null: false
      t.string   :file_path,  null: false
      t.bigint   :file_size,  null: false
      t.datetime :upload_time, null: false
      t.integer  :file_status, null: false, default: 1
    end

    add_index :files, :user_id
    add_foreign_key :files, :users, column: :user_id, on_delete: :cascade

    # 尝试在 DB 层设置默认 CURRENT_TIMESTAMP（兼容可能不支持直接在 create_table 中设置的情况）
    begin
      execute "ALTER TABLE #{quote_table_name(:files)} MODIFY upload_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP"
    rescue => e
      Rails.logger.warn "Could not set DB default CURRENT_TIMESTAMP for files.upload_time: #{e.message}"
    end
  end

  def down
    drop_table :files, if_exists: true
  end
end