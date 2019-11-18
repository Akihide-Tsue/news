class PostsController < ApplicationController

  def index
  end

  def show
  end

  def mail
    TestMailer.testmail(params[:str]).deliver_later  #メーラに作成したメソッドを呼び出す。
    flash[:notice] = "メール送信完了" 
    redirect_to root_url
  end
end