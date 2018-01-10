require "granite_orm/adapter/pg"

class Card < Granite::ORM::Base
  adapter pg
  table_name cards


  # id : Int64 primary key is created for you
  field title : String
  field body : String
  timestamps
end
