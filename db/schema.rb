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

ActiveRecord::Schema.define(version: 20160907201039) do

  create_table "announcements", force: :cascade do |t|
    t.string   "title"
    t.text     "content"
    t.boolean  "accepted"
    t.boolean  "global"
    t.integer  "employee_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "complainants", force: :cascade do |t|
    t.string   "name"
    t.string   "last_name"
    t.integer  "ci"
    t.integer  "phone"
    t.integer  "complain_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "address"
  end

  add_index "complainants", ["complain_id"], name: "index_complainants_on_complain_id"

  create_table "complains", force: :cascade do |t|
    t.text     "description"
    t.string   "protagonists"
    t.string   "zone"
    t.float    "latitude"
    t.float    "longitude"
    t.integer  "crime_id"
    t.integer  "contravertion_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "user_id"
    t.string   "observations"
    t.string   "caseReport"
    t.text     "shortReport"
    t.integer  "patrol_unit_id"
    t.boolean  "ruralArea"
    t.string   "provinceName"
    t.date     "registrationDate"
    t.time     "registrationHour"
    t.string   "complainNumber"
    t.string   "complainPlace"
    t.string   "derivationCase"
  end

  add_index "complains", ["contravertion_id"], name: "index_complains_on_contravertion_id"
  add_index "complains", ["crime_id"], name: "index_complains_on_crime_id"
  add_index "complains", ["patrol_unit_id"], name: "index_complains_on_patrol_unit_id"
  add_index "complains", ["user_id"], name: "index_complains_on_user_id"

  create_table "complainsAux", force: :cascade do |t|
    t.string   "numeroDenuncia"
    t.time     "hora"
    t.date     "fecha"
    t.string   "nombreOperador"
    t.integer  "nroTelefono"
    t.string   "lugarDenuncia"
    t.string   "operador"
    t.string   "nombreDenunciante"
    t.string   "contravencion"
    t.string   "delito"
    t.string   "zonaUrbana"
    t.string   "zonaRural"
    t.string   "direccion"
    t.string   "descripcionHecho"
    t.string   "unidadAsignada"
    t.string   "reporteCaso"
    t.string   "protagonista"
    t.string   "breveInforme"
    t.string   "remisionCaso"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  create_table "contravertions", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "code"
  end

  create_table "crimes", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "code"
  end

  create_table "documents", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "employee", force: :cascade do |t|
    t.string   "position"
    t.string   "profession"
    t.string   "agent_id"
    t.integer  "person_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "employee", ["person_id"], name: "index_employee_on_person_id"

  create_table "employees", force: :cascade do |t|
    t.string   "position"
    t.string   "profession"
    t.string   "agent_id"
    t.integer  "person_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "employees", ["person_id"], name: "index_employees_on_person_id"

  create_table "legal_agents", force: :cascade do |t|
    t.string   "string"
    t.integer  "crime_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "person_id"
  end

  add_index "legal_agents", ["crime_id"], name: "index_legal_agents_on_crime_id"
  add_index "legal_agents", ["person_id"], name: "index_legal_agents_on_person_id"

  create_table "patrol_units", force: :cascade do |t|
    t.string   "code"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "people", force: :cascade do |t|
    t.string   "identification_number"
    t.integer  "identification_type"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "country"
    t.string   "city"
    t.string   "address"
    t.integer  "user_id"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.string   "phone_number"
  end

  add_index "people", ["user_id"], name: "index_people_on_user_id"

  create_table "roles", force: :cascade do |t|
    t.string   "typename"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.integer  "role"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.boolean  "active"
    t.string   "username",               default: "",    null: false
    t.boolean  "password_alteration",    default: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  add_index "users", ["username"], name: "index_users_on_username", unique: true

end
