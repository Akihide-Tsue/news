class NewsMailMailer < ApplicationMailer
  default from: 'news-tenki@tenki.com'

  def testmail(str)
    @str = str
    mail(to: "akihide.tsue@gmail.com", subject: "メールの件名")
  end
end