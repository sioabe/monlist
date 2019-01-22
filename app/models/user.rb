class User < ApplicationRecord
  before_save{ self.email.downcase!}
  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                    uniqueness: {case_sensitive: false }
                    
  has_secure_password
  has_many :ownerships
  has_many :items, through: :ownerships #want,haveどちらのitemも取得する
  #Want
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
  
  #Have
  has_many :haves, class_name:'Have'
  has_many :have_items, through: :haves ,source: :item
  
  def have(item)
    self.haves.find_or_create_by(item_id: item.id)
  end
  
  def unhave(item)
    have = self.haves.find_by(item_id: item.id)
    have.destroy if have
  end
  
  def have?(item)
    self.have_items.include?(item)
  end
end
