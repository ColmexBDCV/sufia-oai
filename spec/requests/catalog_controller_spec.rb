require "rails_helper"

RSpec.describe CatalogController do
  describe "RSS feed" do
    let(:rss_path) { '/catalog.rss' }

    it 'returns a valid response' do
      get rss_path
      expect(response).to be_success
      expect(response.content_type).to eq("application/rss+xml")
    end

    context "with three works" do
      before { create_list(:public_generic_work, 3) }

      it 'shows three items in the feed' do
        get rss_path
        xml = Nokogiri::XML response.body
        expect(xml.xpath("///channel/item").count).to be 3
      end
    end

    context "with an image-based work" do
      let!(:work) { create(:public_generic_work, :with_image) }

      it 'the item contains a media element' do
        get rss_path
        xml = Nokogiri::XML response.body
        media_elements = xml.xpath("///channel/item/media:content")
        image_url = xml.xpath("///channel/item/media:content").first.attributes['url'].value

        expect(media_elements.count).to be 1
        expect(image_url).to include(work.file_sets.first.iiif_id)
      end
    end
  end
end
