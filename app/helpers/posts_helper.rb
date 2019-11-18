module PostsHelper

  require 'uri'
  require 'net/http'
  require 'json'
  require 'date'
  require 'open-uri'
  require 'kconv'
  require 'rexml/document'

#その1　
def tenki(todouhuken)
  if todouhuken == "01"
    hokkaido = "http://weather.livedoor.com/forecast/webservice/json/v1?city=016010"
    info(hokkaido)
  elsif todouhuken == "08"
    tokyo = "http://weather.livedoor.com/forecast/webservice/json/v1?city=130010"
    info(tokyo)
  elsif todouhuken == "25"
    osaka = "http://weather.livedoor.com/forecast/webservice/json/v1?city=270000"
    info(osaka)
  else
    "テストアプリのため未実装です。現在は北海道、東京、大阪のみ確認が可能です"
  end
end

def info(place)
  uri = URI.parse(place)
  res = Net::HTTP.get(uri)
  res = JSON.parse(res)
  location = res["location"]["city"]
  today = Date.today.day
  tomorrow = Date.today.day + 1
  forecasts = res["forecasts"]

  today_forecast = forecasts[0]
  today_telop = today_forecast["telop"]
  today_max = today_forecast.dig(*%w[temperature max celsius]) || "データなし"
  today_min = today_forecast.dig(*%w[temperature min celsius]) || "データなし"

  tomorrow_forecast = forecasts[1]
  tomorrow_telop = tomorrow_forecast["telop"]
  tomorrow_max = tomorrow_forecast.dig(*%w[temperature max celsius]) || "データなし"
  tomorrow_min = tomorrow_forecast.dig(*%w[temperature min celsius]) || "データなし"

  " #{location}の天気：
  今日(#{today}日)  ：#{today_telop}、最高気温:#{today_max}、最低気温:#{today_min}\n  明日(#{tomorrow}日)  ：#{tomorrow_telop}、最高気温:#{tomorrow_max}、最低気温:#{tomorrow_min}"
end

#その2　　https://www.drk7.jp/weather/
def kousui(todouhuken)



if todouhuken == "01"
    hokkaido = "http://www.drk7.jp/weather/xml/01.xml"
    xpath = 'weatherforecast/pref/area[11]/' #石狩
    show_kousui(hokkaido,xpath)
elsif todouhuken == "08"
  tokyo = "http://www.drk7.jp/weather/xml/13.xml"
  xpath = 'weatherforecast/pref/area[4]/' #東京
  show_kousui(tokyo,xpath)
elsif todouhuken == "25"
  osaka = "http://www.drk7.jp/weather/xml/27.xml"
  xpath = 'weatherforecast/pref/area[1]/' #大阪
  show_kousui(osaka,xpath)
  else
    "降水確率：　未実装"
end
end

def show_kousui(url,xpath)
xml  = open( url ).read.toutf8
doc = REXML::Document.new(xml)


per06to12 = doc.elements[xpath + 'info[2]/rainfallchance/period[2]'].text
per12to18 = doc.elements[xpath + 'info[2]/rainfallchance/period[3]'].text
per18to24 = doc.elements[xpath + 'info[2]/rainfallchance/period[4]'].text

"降水確率：　6〜12時：#{per06to12}％、\n12〜18時：#{per12to18}％、\n18〜24時：#{per18to24}％"

end



end