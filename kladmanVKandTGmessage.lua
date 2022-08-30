script_author('olol321 & Крипер')
script_version('1.5')
local msg = ""
local tag = 'КладХелпер: '


-----[ТУТ ДАННЫЕ ВКОНТАКТЕ!]
token_vk = '' --токен группы
chat_id = '' --ид беседы, дефолт 1(если в группе создана всего 1 беседа то пишите 1, блять често меня этот вопрос заебал, заходите не просто в беседу, а через группу в беседу)
groupid_vk = '' --ид группы(не буквенный)
--[ТУТ ДАННЫЕ ТЕЛЕГРАМА!]
chat_idtg = '' -- чат ID юзера
token_tg = '' -- токен бота тг
------
mode = 1 ---если мод 1 то вк, если 2 то телеграм





local sampev = require("samp.events")
local effil = require("effil")
requests = require 'requests'
local encoding = require 'encoding'
encoding.default = 'CP1251'
u8 = encoding.UTF8
require "lib.moonloader"

function urlencode(str)
   if (str) then
      str = string.gsub (str, "\n", "\r\n")
      str = string.gsub (str, "([^%w ])",
      function (c) return string.format ("%%%02X", string.byte(c)) end)
      str = string.gsub (str, " ", "+")
   end
   return str
end


function main()
	if not isSampLoaded() or not isSampfuncsLoaded() then return end
	while not isSampAvailable() do wait(100) end
	sampAddChatMessage(tag..'Успешно загружен', -1)
	sampAddChatMessage('Автор: vk.com/beschastnov123 & Крипер', -2)
	
	if mode == 1 then
	sampAddChatMessage("Включен режим 1 (ВКонтакте)", 0xFFFF0000)
	SendVkNotification("(&#10071;) Кладмен зашел на сервер!\nСейчас начнем искать...")
	else
	sampAddChatMessage("Включен режим 2 (Телеграм)", 0xFFFF0000)
	sendTelegramNotification('Кладмен зашел на сервер!\nСейчас начнем искать...')
	end

    while true do 
        wait(1)
		--тут если сообщение Server closed the connection или You are banned from this server мы отсылаем сообщение в вк
		local chatstring = sampGetChatString(99)
        if chatstring == "Server closed the connection." or chatstring == "You are banned from this server." then
		sampDisconnectWithReason(false)
			--wait(1000)
			if mode == 1 then
			SendVkNotification('Аккаунт вышел с сервера, причина: кик/бан \n *Смотри последнее сообщение(если ничего нет, значит кикнуло с сервера)')
			else
			sendTelegramNotification('Аккаунт вышел с сервера, причина: кик/бан \n *Смотри последнее сообщение(если ничего нет, значит кикнуло с сервера)')
			end
		end
		--wait(-1)
		end
end

--[Если в чате появляется сообщение содержящее в себе Администратор и ваш ник, то оно отправляет в вк сообщение]
function sampev.onServerMessage(color, text)  
    local _, idd = sampGetPlayerIdByCharHandle(PLAYER_PED)
    if text:find('Администратор') and (sampIsPlayerConnected(id) and text:find(sampGetPlayerNickname(idd))) then
		msg = text:gsub("{......}", "")
		if mode == 1 then
		SendVkNotification('(&#10071;) Кладмен был пойман ! причина: Статья 228 УК РФ. [БАН] \n\n' ..msg)
		else
		sendTelegramNotification('Кладмен был пойман ! причина: Статья 228 УК РФ. [БАН] \n\n' ..msg)
		end
    end
end

function sampev.onCreateObject(objectId, data)
    if data.modelId == 1271 then --1271
        sampAddChatMessage(tag..'Появился клад: '..data.position.x..' '..data.position.y..' '..data.position.z, -1)
		sampProcessChatInput('/mpos' ..data.position.xx..' '..data.position.xy..' '..data.position.xz)
		sampAddChatMessage('поставил метку на координаты: ' ..data.position.xx..' '..data.position.xy..' '..data.position.xz)
		
		ip, port = sampGetCurrentServerAddress()
		name = sampGetCurrentServerName()
		sampAddChatMessage(name, 0xFFFF0000)
		
		xx = data.position.x
		xy = data.position.y
		xz = data.position.z
		vms = math.floor(xx)..", "..math.floor(xy)..", "..math.floor(xz)
		gor = getCityFromCoords(xx, xy, xz)
		if gor == 1 then
		gorod = 'Лос Сантос'	
		end
		if gor == 2 then
		gorod = 'Сан Фиерро'	
		end
		if gor == 3 then
		gorod = 'Лас Вентурас'	
		end
		if gor == 0 then
		gorod = 'Неизвестное место'	
		end
			
		if mode == 1 then
		SendVkNotification("Сервер: " ..name.. "\n (&#10071;) Найден клад!\n /setmarker " ..math.floor(data.position.x)..", " ..math.floor(data.position.y)..", " ..math.floor(data.position.z).. "\n Город: " ..gorod)
		else
		sendTelegramNotification("Сервер: " ..name.. "\n Найден клад!\n /setmarker " ..math.floor(data.position.x)..", " ..math.floor(data.position.y)..", " ..math.floor(data.position.z).. "\n Город: " ..gorod)
		end
		
    end
end

u = 0

function random(x, y)
    u = u + 1
    if x ~= nil and y ~= nil then
        return math.floor(x +(math.random(math.randomseed(os.time()+u))*999999 %y))
    else
        return math.floor((math.random(math.randomseed(os.time()+u))*100))
    end
end

function threadHandle(runner, url, args, resolve, reject)
    local t = runner(url, args)
    local r = t:get(0)
    while not r do
        r = t:get(0)
        wait(0)
    end
    local status = t:status()
    if status == 'completed' then
        local ok, result = r[1], r[2]
        if ok then resolve(result) else reject(result) end
    elseif err then
        reject(err)
    elseif status == 'canceled' then
        reject(status)--msg
    end
    t:cancel(0)
end

function requestRunner()
    return effil.thread(function(u, a)
        local https = require 'ssl.https'
        local ok, result = pcall(https.request, u, a)
        if ok then
            return {true, result}
        else
            return {false, result}
        end
    end)
end

function async_http_request(url, args, resolve, reject)
    local runner = requestRunner()
    if not reject then reject = function() end end
    lua_thread.create(function()
        threadHandle(runner, url, args, resolve, reject)
    end)
end

function encodeUrl(str)
    str = str:gsub(' ', '%+')
    str = str:gsub('\n', '%%0A')
    return u8:encode(str, 'CP1251')
end

------тут типа отправка сообщений
function sendTelegramNotification(msgtg) -- функция для отправки сообщения юзеру
    msgtg = msgtg:gsub('{......}', '') --тут типо убираем цвет
    msgtg = encodeUrl(msgtg) -- ну тут мы закодируем строку
	sampAddChatMessage("Отправляем сообщение в телеграм...", 0xFFFF0000)
    async_http_request('https://api.telegram.org/bot' .. token_tg .. '/sendMessage?chat_id=' .. chat_idtg .. '&text='..msgtg,'', function(result) end) -- а тут уже отправка
end

function SendVkNotification(msgvk) -- функция для отправки сообщения юзеру
    sampAddChatMessage("Отправляем сообщение в ВКонтакте...", 0xFFFF0000)
	requests.get("https://api.vk.com/method/messages.send?v=5.103&access_token="..token_vk.."&chat_id="..chat_id.."&message="..urlencode(u8:encode(msgvk, 'CP1251')).."&group_id="..groupid_vk.."&random_id="..random(1111111111, 9999999999))
end
