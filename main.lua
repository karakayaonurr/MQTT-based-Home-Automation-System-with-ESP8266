wifi.setmode(wifi.STATION)

config = {}
config["ssid"] = "Gokhan"
config["pwd"] = "41gokhan34"
wifi.sta.config(config)
gpio.mode(1,gpio.OUTPUT)
gpio.mode(2,gpio.OUTPUT)
gpio.mode(3,gpio.OUTPUT)
gpio.write(1, gpio.LOW)
gpio.write(2, gpio.LOW)
gpio.write(3, gpio.LOW)
MqttServer = 'test.mosquitto.org'
MqttPort = 1883
MqttUser = ocalxylb
MqttPassword = 'M1uprmcFOqP4'
function listen()
-- initiate the mqtt client and set keepalive timer to 120sec
mqtt = mqtt.Client("ClientID", 120)

mqtt:on("connect", function(con) print ("connected") end)
mqtt:on("offline", function(con) print ("offline") end)

-- on receive message
mqtt:on("message", function(conn, topic, data)
  print(topic .. ":" )
  if data ~= nil then
    print(data)
    if data == "yesil on" then
        gpio.write(1, gpio.HIGH)
        send()
    elseif data == "yesil off" then
        gpio.write(1, gpio.LOW)
        send()
    elseif data == "beyaz on" then
        gpio.write(2, gpio.HIGH)
        send()
    elseif data == "beyaz off" then
        gpio.write(2, gpio.LOW)
        send()
    elseif data == "mavi on" then
        gpio.write(3, gpio.HIGH)
        send()
    elseif data == "mavi off" then
        gpio.write(3, gpio.LOW)
        send()
    elseif data == "0" then
        gpio.write(1, gpio.LOW)
        gpio.write(2, gpio.LOW)
        gpio.write(3, gpio.LOW)
        send()
    elseif data == "1" then
        gpio.write(1, gpio.HIGH)
        gpio.write(2, gpio.HIGH)
        gpio.write(3, gpio.HIGH)
        send()
    end
  end
end)

mqtt:connect(MqttServer, MqttPort, 0, function(conn) 
   print("connected")
   -- subscribe topic with qos = 0
   mqtt:subscribe("Isik" ,0, function(conn) 
     -- publish a message with data = my_message, QoS = 0, retain = 0
     mqtt:publish("Durum", "Uygulandı" ,0,0, function(conn) 
       print("sent") 
     end)
   end)
end)

end

function send()
    if gpio.read(1) == 1 then
        mqtt:publish("Durum", "on", 0, 0)
    elseif gpio.read(1) == 0 then
        mqtt:publish("Durum", "off", 0, 0)
    elseif gpio.read(1) == nil then
        mqtt:publish("Durum", "ERROR: DECIVE NOT FOUND", 0, 0)
    end
end

tmr.alarm(1, 1000, 1, function()
    if wifi.sta.getip() == nil then
        print("Waiting for IP address...")
        -- timeout ekle
    else
        tmr.stop(1)
        print("wait 3 seconds")
        tmr.alarm(0, 3000, 0, listen)
    end
end)
