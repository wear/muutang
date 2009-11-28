# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20091128133345) do

  create_table "comments", :force => true do |t|
    t.string   "title",            :limit => 50, :default => ""
    t.text     "comment"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["commentable_id"], :name => "index_comments_on_commentable_id"
  add_index "comments", ["commentable_type"], :name => "index_comments_on_commentable_type"
  add_index "comments", ["user_id"], :name => "index_comments_on_user_id"

  create_table "posts", :force => true do |t|
    t.string   "title"
    t.text     "body"  
    t.integer  "user_id"
    t.integer  "category_id",:default => 0
    t.boolean  "visible",:default => true
    t.boolean  "top", :default => false
    t.integer  "comments_count", :default => 0
    t.boolean  "can_comment",:default => true
    t.datetime "created_at"
    t.datetime "updated_at"
  end 
  
  add_index "posts", ["category_id"], :name => "index_post_on_category_id"      
  add_index "posts", ["user_id"], :name => "index_posts_on_user_id"             
  
  create_table "categories", :force => true do |t|
    t.string   "name"
    t.integer  "position",:null => false 
    t.string   "kind" 
  end

  create_table "users", :force => true do |t|
    t.string   "login",                     :limit => 40
    t.string   "email",                     :limit => 100
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token",            :limit => 40
    t.datetime "remember_token_expires_at"
    t.string   "activation_code",           :limit => 40
    t.datetime "activated_at"
    t.integer  'posts_count'
    t.string   "identity_url"
  end            
          
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true  
  
  create_table  "profiles", :force => true do |t|    
    t.integer 'user_id'   
    t.string   "name",                      :limit => 100, :default => ""  
    t.string  'phone_number'
    t.string  'website'
    t.string  'city' 
    t.string  'state'
    t.string  'country'
    t.string  'company'
    t.string  'company_category'
    t.string  'company_size'
    t.string  'industry'
    t.string  'title'
    t.string  'work_experience'
    t.string  'interesting' 
    t.text     "desc"  
    t.datetime "avatar_updated_at"
    t.integer  "avatar_file_size"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "prestige"   
  end  
  
  add_index "profiles", ["user_id"], :name => "index_profiles_on_user_id"
  
  create_table  "skills", :force => true do |t|
    t.integer 'user_id'
    t.string  'name'
    t.integer 'experience_by_year'
    t.text    'desc'
  end

  add_index "skills", ["user_id"], :name => "index_skills_on_user_id" 
    
  create_table "roles", :force => true do |t|
     t.string "title"
   end 
   
  create_table "roles_users", :id => false, :force => true do |t|
     t.integer "role_id"
     t.integer "user_id"
   end   
   
   create_table "recommands", :force => true do |t|
     t.string   "title"
     t.string   "url"  
     t.integer  "comments_count", :default => 0
     t.integer  "recommandations_count",:default => 0
     t.datetime "created_at"
     t.datetime "updated_at"
   end       
   
   add_index "recommands", ["title"], :name => "index_recommands_on_title"
      
   create_table "recommandations", :force => true do |t|
     t.integer   "user_id"
     t.integer   "recommand_id" 
     t.text      "desc" 
     t.datetime  "created_at"
     t.datetime  "updated_at"
   end                                                                       
        
   add_index "recommandations", ["user_id"], :name => "index_recommandations_on_user_id"
   add_index "recommandations", ["user_id"], :name => "index_recommandations_on_recommand_id"
   

    create_table :jobs,:force => true do |t|
     t.string 'company'
     t.string 'company_url' 
     t.string 'position'    
     t.string 'salary' 
     t.string 'job_address'
     t.text   'desc'
     t.string  "job_type" 
     t.boolean 'visible',:default => false
     t.string 'contact_email'       
     t.string  'contact_name'
     t.string  'contact_phone'
     t.timestamps
   end
   
   create_table :open_id_authentication_associations, :force => true do |t|
     t.integer :issued, :lifetime
     t.string :handle, :assoc_type
     t.binary :server_url, :secret
   end

   create_table :open_id_authentication_nonces, :force => true do |t|
     t.integer :timestamp, :null => false
     t.string :server_url, :null => true
     t.string :salt, :null => false
   end   
   
   create_table :pages, :force => true do |t|
     t.integer 'parent_id'  ,:null => false ,:default => 0
     t.integer 'position'
     t.string  "name"
     t.string  "category"
     t.text    "content"
     t.timestamps
   end
          
   

end
