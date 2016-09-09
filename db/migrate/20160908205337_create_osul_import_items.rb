class CreateOsulImportItems < ActiveRecord::Migration
  def change
    create_table :osul_import_items do |t|
      t.string :fid
      t.string :unit
      t.string :date_uploaded
      t.string :identifier
      t.string :resource_type
      t.text :title
      t.string :creator
      t.string :contributor
      t.text :description
      t.text :bibliographic_citation
      t.text :tag
      t.text :rights
      t.text :provenance
      t.text :publisher
      t.text :date_created
      t.text :subject
      t.text :language
      t.text :based_near
      t.text :related_url
      t.text :work_type
      t.text :spatial
      t.text :alternative
      t.text :temporal
      t.text :format
      t.text :staff_notes
      t.text :source
      t.text :part_of
      t.string :preservation_level_rationale
      t.string :preservation_level
      t.string :collection_identifier
      t.string :visibility
      t.string :collection_id
      t.string :depositor
      t.string :handle
      t.string :batch_id
      t.string :collection_id
      t.string :admin_policy_id
      t.text :materials
      t.text :measurements
      t.string :filename
      t.string :image_uri

      t.timestamps null: false
    end
  end
end
