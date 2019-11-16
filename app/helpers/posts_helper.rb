module PostsHelper

  require 'uri'
  require 'net/http'
  require 'json'
  require 'date'

def tenki(todouhuken)
  if todouhuken == "01"
    hokkaido = "http://weather.livedoor.com/forecast/webservice/json/v1?city=016010"
    info(hokkaido)
  elsif todouhuken == "08"
    tokyo = "http://weather.livedoor.com/forecast/webservice/json/v1?city=130010"
    info(tokyo)
  else
    "未設定です"
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
  今日(#{today}日)  ：#{today_telop}、最高気温:#{today_max}、最低気温:#{today_min}明日(#{tomorrow}日)\n  ：#{tomorrow_telop}、最高気温:#{tomorrow_max}、最低気温:#{tomorrow_min}"

end
end