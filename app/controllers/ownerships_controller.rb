class OwnershipsController < ApplicationController
  def create
    #まず Item.find_by して見つかればテーブルに保存されていたインスタンスを返し、見つからなければ Item.new して新規作成する便利メソッド
    @item = Item.find_or_initialize_by(code: params[:item_code])
    
    unless @item.persisted?
      # @item が保存されていない場合、先に @item を保存する
      results = RakutenWebService::Ichiba::Item.search(itemCode: @item.code)
    
      @item = Item.new(read(results.first))
      @item.save
    end
    
    #want関係として保存
    if params[:type] == 'Want'
      current_user.want(@item)
      flash[:success] = '商品をWantしました'
    #have関係  
    elsif params[:type]=='Have' then
      current_user.have(@item)
      flash[:success] = '商品をHaveしました'
    end
    
    redirect_back(fallback_location: root_path)
  end

  def destroy
    @item = Item.find(params[:item_id])
    
    #want関係
    if params[:type] == 'Want'
      current_user.unwant(@item)
      flash[:success]='商品のWantを解除しました'
    #have関係
    elsif params[:type] == 'Have' then
      current_user.unhave(@item)
      flash[:success]='商品のHaveを解除しました'
    end
    
    redirect_back(fallback_location: root_path)
  end
end
