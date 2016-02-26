class AddLeadsCountToLandingVersions < ActiveRecord::Migration
  def change
    add_column :landing_versions, :leads_count, :integer, null: false, default: 0
    rename_column :collections, :items_count, :leads_count

    Collection.find_each do |c|
      Collection.reset_counters c.id, :items
    end

    LandingVersion.find_each do |v|
      LandingVersion.reset_counters v.id, :leads
    end
  end
end