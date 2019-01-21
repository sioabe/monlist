class User < ApplicationRecord
  before_save{ self.email.downcase!}
  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                    uniqueness: {case_sensitive: false }
                    
  has_secure_password
  has_many :ownerships
  has_many :items, through: :ownerships #want,haveどちらのitemも取得する
  has_many :wants
  has_many :want_items, through: :wants, source: :item  #wantのみのitemを取得する
  
  def want(item)
    self.wants.find_or_create_by(item_id: item.id)
  end
  
  def unwant(item)
    want = self.wants.find_by(item_id: item.id)
    want.destroy if want
  end

  def want?(item)
    self.want_items.include?(item)  #self.want_itemsでuserのwant_itemsを全て取り出し、itemが含まれていないか確認する
  end
end
