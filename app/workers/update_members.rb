class UpdateMembers
  attr_accessor :collection_id

  def queue
    :event
  end

  def initialize(collection_id)
    self.collection_id = collection_id
  end

  def run
    collection = Collection.find(self.collection_id)
    collection.members.each do |member|
      member.save
    end
  end
end
