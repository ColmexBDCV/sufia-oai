class ConacytStat < ActiveRecord::Base
    validates :work, :category, :author, presence: true
    enum category: { articulos: 0, descargas: 1 }
end
