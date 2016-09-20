class CreateTableAuxAndAddColumnsToComplains < ActiveRecord::Migration

    def change
      add_column :complains, :ruralArea, :boolean
      add_column :complains,:provinceName, :string
      add_column :complains, :registrationDate, :date
      add_column :complains, :registrationHour, :time
      add_column :complains, :complainNumber, :string
      add_column :complains, :complainPlace, :string
      add_column :complains, :derivationCase, :string


  end
end
