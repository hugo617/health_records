class CreateParams < ActiveRecord::Migration[7.0]
  def up
    create_table :params do |t|
      t.string  :param_type, null: false
      t.string  :param_name, null: false
      t.string  :param_code, null: false
      t.text    :param_desc
      t.integer :sort,       null: false, default: 0
    end

    add_index :params, :param_code, unique: true, name: 'index_params_on_param_code'
  end

  def down
    drop_table :params, if_exists: true
  end
end