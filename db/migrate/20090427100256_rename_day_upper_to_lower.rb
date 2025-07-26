class RenameDayUpperToLower < ActiveRecord::Migration
  def self.up
     rename_column :days, :Sunday, :sunday
     rename_column :days, :Monday, :monday
     rename_column :days, :Tuesday, :tuesday
     rename_column :days, :Wednesday, :wednesday
     rename_column :days, :Thursday, :thursday
     rename_column :days, :Friday, :friday
     rename_column :days, :Saturday, :saturday
  end

  def self.down
     rename_column :days, :sunday, :Sunday
     rename_column :days, :monday, :Monday
     rename_column :days, :tuesday, :Tuesday
     rename_column :days, :wednesday, :Wednesday
     rename_column :days, :thursday, :Thursday
     rename_column :days, :friday, :Friday
     rename_column :days, :saturday, :Saturday

  end
end
