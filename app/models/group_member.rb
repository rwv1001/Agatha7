class GroupMember
  attr_reader :name;
  attr_reader :id;
  def initialize(name, id)
 #   Rails.logger.error( "new GroupMember" );
    @name =name;
    @id = id;
  end
end