class CreateEntityParamRels < ActiveRecord::Migration[7.0]
  def up
    create_table :entity_param_rels do |t|
      t.string   :rel_type,   null: false
      t.bigint   :entity_id,  null: false
      t.bigint   :param_id,   null: false
      t.datetime :start_time
      t.datetime :end_time
      t.integer  :rel_status, null: false, default: 1
    end

    add_index :entity_param_rels, [:rel_type, :entity_id, :param_id],
              unique: true, name: 'index_entity_param_rels_on_rel_type_entity_id_param_id'
    add_index :entity_param_rels, :param_id

    # 外键关联 params.id 并级联删除
    add_foreign_key :entity_param_rels, :params, column: :param_id, on_delete: :cascade
  end

  def down
    remove_foreign_key :entity_param_rels, column: :param_id if foreign_key_exists?(:entity_param_rels, :params, column: :param_id)
    drop_table :entity_param_rels, if_exists: true
  end
end