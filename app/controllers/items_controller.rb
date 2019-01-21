class ItemsController < ApplicationController
  def new
    @items = []   #検索ページitems#newが開かれた時用。予め初期化しておく。
    
    @keyword = params[:keyword]
    if @keyword.present?
      results = RakutenWebService::Ichiba::Item.search({
        keyword: @keyword,
        imageFlag: 1,
        hits: 20,
      })
      results.each do |result|
        item = Item.new(read(result))
        @items << item
      end
    end
  end
  
  private
  
  def read(result)
    code = result['itemCode']
    name = result['itemName']
    url = result['itemUrl']
    image_url = result['mediumImageUrls'].first['imageUrl'].gsub('?_ex=128x128','')
    
    {
      code: code,
      name: name,
      url: url,
      image_url: image_url,
    }
  end
end
