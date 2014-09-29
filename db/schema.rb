# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140928165832) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "citizen_budget_model_organization_translations", force: true do |t|
    t.integer  "citizen_budget_model_organization_id",              null: false
    t.string   "locale",                                            null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name",                                 default: "", null: false
  end

  add_index "citizen_budget_model_organization_translations", ["citizen_budget_model_organization_id"], name: "index_c552302e912cf73047023f2dfc3372fbc32967d6", using: :btree
  add_index "citizen_budget_model_organization_translations", ["locale"], name: "index_citizen_budget_model_organization_translations_on_locale", using: :btree

  create_table "citizen_budget_model_organizations", force: true do |t|
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "citizen_budget_model_question_translations", force: true do |t|
    t.integer  "citizen_budget_model_question_id",              null: false
    t.string   "locale",                                        null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name",                             default: "", null: false
    t.text     "title",                            default: "", null: false
    t.text     "description",                      default: "", null: false
    t.text     "modal",                            default: "", null: false
    t.text     "popover",                          default: "", null: false
    t.string   "labels",                           default: [], null: false, array: true
    t.string   "unit_name",                        default: "", null: false
    t.string   "placeholder",                      default: "", null: false
  end

  add_index "citizen_budget_model_question_translations", ["citizen_budget_model_question_id"], name: "index_6f66eb2c3052d6e00221297d74a882e67880fdba", using: :btree
  add_index "citizen_budget_model_question_translations", ["locale"], name: "index_citizen_budget_model_question_translations_on_locale", using: :btree

  create_table "citizen_budget_model_questions", force: true do |t|
    t.integer  "section_id"
    t.string   "machine_name",  default: "",    null: false
    t.float    "default_value"
    t.float    "unit_value"
    t.string   "account",       default: "",    null: false
    t.string   "widget",        default: "",    null: false
    t.float    "options",       default: [],    null: false, array: true
    t.boolean  "revenue",       default: false
    t.integer  "maxlength"
    t.boolean  "required",      default: false
    t.integer  "rows"
    t.integer  "cols"
    t.integer  "size"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "html_class",    default: "",    null: false
  end

  add_index "citizen_budget_model_questions", ["section_id"], name: "index_citizen_budget_model_questions_on_section_id", using: :btree

  create_table "citizen_budget_model_section_translations", force: true do |t|
    t.integer  "citizen_budget_model_section_id",              null: false
    t.string   "locale",                                       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title",                           default: "", null: false
    t.text     "description",                     default: "", null: false
    t.text     "popover",                         default: "", null: false
    t.text     "modal",                           default: "", null: false
  end

  add_index "citizen_budget_model_section_translations", ["citizen_budget_model_section_id"], name: "index_2b79c59d2a47f33d3e927dae21105b97719ec5c0", using: :btree
  add_index "citizen_budget_model_section_translations", ["locale"], name: "index_citizen_budget_model_section_translations_on_locale", using: :btree

  create_table "citizen_budget_model_sections", force: true do |t|
    t.integer  "simulator_id"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "html_class",   default: "", null: false
  end

  add_index "citizen_budget_model_sections", ["simulator_id"], name: "index_citizen_budget_model_sections_on_simulator_id", using: :btree

  create_table "citizen_budget_model_simulator_translations", force: true do |t|
    t.integer  "citizen_budget_model_simulator_id",              null: false
    t.string   "locale",                                         null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name",                              default: "", null: false
  end

  add_index "citizen_budget_model_simulator_translations", ["citizen_budget_model_simulator_id"], name: "index_b5903b0d0fd09cf4e469b0fadf1c02d7a8b9e95f", using: :btree
  add_index "citizen_budget_model_simulator_translations", ["locale"], name: "index_citizen_budget_model_simulator_translations_on_locale", using: :btree

  create_table "citizen_budget_model_simulators", force: true do |t|
    t.integer  "organization_id"
    t.string   "equation",        default: "",    null: false
    t.string   "distribution",    default: "",    null: false
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "active",          default: false
  end

  add_index "citizen_budget_model_simulators", ["organization_id"], name: "index_citizen_budget_model_simulators_on_organization_id", using: :btree

  create_table "citizen_budget_model_users", force: true do |t|
    t.integer  "organization_id"
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "citizen_budget_model_users", ["email"], name: "index_citizen_budget_model_users_on_email", unique: true, using: :btree
  add_index "citizen_budget_model_users", ["organization_id"], name: "index_citizen_budget_model_users_on_organization_id", using: :btree
  add_index "citizen_budget_model_users", ["reset_password_token"], name: "index_citizen_budget_model_users_on_reset_password_token", unique: true, using: :btree

  create_table "thing_translations", force: true do |t|
    t.integer  "thing_id",                null: false
    t.string   "locale",                  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name",       default: "", null: false
  end

  add_index "thing_translations", ["locale"], name: "index_thing_translations_on_locale", using: :btree
  add_index "thing_translations", ["thing_id"], name: "index_thing_translations_on_thing_id", using: :btree

  create_table "things", force: true do |t|
  end

end
