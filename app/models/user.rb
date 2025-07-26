require 'digest/sha1'


class User < ActiveRecord::Base
  @@class_name ||= "User"
def class_name
  return @@class_name
end
def self.set_controller(search_controller_)
  @@search_controller = search_controller_
end

def search_controller
  return @@search_controller
end
  USER_WHERE_STR = "";
  has_many :display_filters, :class_name => "DisplayFilter", :dependent => :destroy
  has_many :format_elements, :class_name => "FormatElement", :dependent => :destroy
  has_many :group_users, :class_name => "GroupUser", :dependent => :destroy
  has_many :groups, :class_name=>"Group"
  has_many :open_records, :class_name => "OpenRecord", :dependent => :destroy
  belongs_to :person, :class_name => "Person", :foreign_key => "person_id"

  validates_presence_of     :name
  validates_uniqueness_of   :name
 
  attr_accessor :password_confirmation
  validates_confirmation_of :password
  attr_accessor :old_password

  validate :password_non_blank
  

  
  def self.authenticate(name, password)
    user = self.find_by_name(name)
    if user && name
      expected_password = encrypted_password(password, user.salt)
      if user.hashed_password != expected_password
        user = nil
      end
    end
    user
  end
  
  
  # 'password' is a virtual attribute
  
  def password
    @password
  end
  
  def password=(pwd)
    @password = pwd
    return if pwd.blank?
    create_new_salt
    self.hashed_password = User.encrypted_password(self.password, self.salt)
  end
  
  def after_destroy
    if User.count.zero?
      raise "Can't delete last user"
    end
  end     
  

private

  def password_non_blank
    errors.add(:password, "Missing password") if hashed_password.blank?
  end

  
  
  def create_new_salt
    self.salt = self.object_id.to_s + rand.to_s
  end
  
  
  
  def self.encrypted_password(password, salt)
    string_to_hash = password + "wibble" + salt
    Digest::SHA1.hexdigest(string_to_hash)
  end
  

end


