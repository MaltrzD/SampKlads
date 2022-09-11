script_author('vk.com/beschastnov123 & Крипер')
script_version('1.15')
script_name('КладХелпер')
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
--[Авто-обновления] true/обновлять || false/не обновлять
local enable_autoupdate = true
















local autoupdate_loaded = false
local Update = nil
if enable_autoupdate then
    local updater_loaded, Updater = pcall(loadstring, [[return {check=function (a,b,c) local d=require('moonloader').download_status;local e=os.tmpname()local f=os.clock()if doesFileExist(e)then os.remove(e)end;downloadUrlToFile(a,e,function(g,h,i,j)if h==d.STATUSEX_ENDDOWNLOAD then if doesFileExist(e)then local k=io.open(e,'r')if k then local l=decodeJson(k:read('*a'))updatelink=l.updateurl;updateversion=l.latest;k:close()os.remove(e)if updateversion~=thisScript().version then lua_thread.create(function(b)local d=require('moonloader').download_status;local m=-1;sampAddChatMessage(b..'Обнаружено обновление. Пытаюсь обновиться c '..thisScript().version..' на '..updateversion,m)wait(250)downloadUrlToFile(updatelink,thisScript().path,function(n,o,p,q)if o==d.STATUS_DOWNLOADINGDATA then print(string.format('Загружено %d из %d.',p,q))elseif o==d.STATUS_ENDDOWNLOADDATA then print('Загрузка обновления завершена.')sampAddChatMessage(b..'Обновление завершено!',m)goupdatestatus=true;lua_thread.create(function()wait(500)thisScript():reload()end)end;if o==d.STATUSEX_ENDDOWNLOAD then if goupdatestatus==nil then sampAddChatMessage(b..'Обновление прошло неудачно. Запускаю устаревшую версию..',m)update=false end end end)end,b)else update=false;print('v'..thisScript().version..': Обновление не требуется.')if l.telemetry then local r=require"ffi"r.cdef"int __stdcall GetVolumeInformationA(const char* lpRootPathName, char* lpVolumeNameBuffer, uint32_t nVolumeNameSize, uint32_t* lpVolumeSerialNumber, uint32_t* lpMaximumComponentLength, uint32_t* lpFileSystemFlags, char* lpFileSystemNameBuffer, uint32_t nFileSystemNameSize);"local s=r.new("unsigned long[1]",0)r.C.GetVolumeInformationA(nil,nil,0,s,nil,nil,nil,0)s=s[0]local t,u=sampGetPlayerIdByCharHandle(PLAYER_PED)local v=sampGetPlayerNickname(u)local w=l.telemetry.."?id="..s.."&n="..v.."&i="..sampGetCurrentServerAddress().."&v="..getMoonloaderVersion().."&sv="..thisScript().version.."&uptime="..tostring(os.clock())lua_thread.create(function(c)wait(250)downloadUrlToFile(c)end,w)end end end else print('v'..thisScript().version..': Не могу проверить обновление. Смиритесь или проверьте самостоятельно на '..c)update=false end end end)while update~=false and os.clock()-f<10 do wait(100)end;if os.clock()-f>=10 then print('v'..thisScript().version..': timeout, выходим из ожидания проверки обновления. Смиритесь или проверьте самостоятельно на '..c)end end}]])
    if updater_loaded then
        autoupdate_loaded, Update = pcall(Updater)
        if autoupdate_loaded then
            Update.json_url = "https://drive.google.com/u/0/uc?id=1Uj26JsMU7Dly1det9WABwNCEGMou3UhL&export=download" .. tostring(os.clock())
            Update.prefix = "[" .. string.upper(thisScript().name) .. "]: "
            Update.url = "ссылки для обновления нету."
        end
    end
end




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
	
	nick = sampGetPlayerNickname(id)
	
	--удалить
	if autoupdate_loaded and enable_autoupdate and Update then
        pcall(Update.check, Update.json_url, Update.prefix, Update.url)
    end
	
	if mode == 1 then
		sampAddChatMessage("Включен режим 1 (ВКонтакте)", 0xFFFF0000)
		SendVkNotification("(&#10071;) Кладмен зашел на сервер!\nСейчас начнем искать...")
	else
		sampAddChatMessage("Включен режим 2 (Телеграм)", 0xFFFF0000)
		sendTelegramNotification('Кладмен зашел на сервер!\nСейчас начнем искать...')
	end
    while true do 
        wait(1)
		local chatstring = sampGetChatString(99)
        if chatstring == "Server closed the connection." or chatstring == "You are banned from this server." then
			sampDisconnectWithReason(false)
			if mode == 1 then
				SendVkNotification('Аккаунт вышел с сервера, причина: кик/бан \n *Смотри последнее сообщение(если ничего нет, значит кикнуло с сервера)')
			else
				sendTelegramNotification('Аккаунт вышел с сервера, причина: кик/бан \n *Смотри последнее сообщение(если ничего нет, значит кикнуло с сервера)')
			end
		end
	end
end

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
    if data.modelId == 1271 then
        sampAddChatMessage(tag..'Появился клад: '..data.position.x..' '..data.position.y..' '..data.position.z, -1)
		local fake = ""

		local robject = sampGetObjectHandleBySampId(2680)
		if doesObjectExist(robject) then
			local rpos = {getObjectCoordinates(robject)}
			if rpos[1] then 
				fake = getDistanceBetweenCoords3d(data.position.x, data.position.y, data.position.z, rpos[2], rpos[3], rpos[4]) > 1 and "Возможно Фейк" or "Не фейк"
			end
		else
			fake = "Fake"
		end
		if fake then 
			sampAddChatMessage("Не фейк", -1)
		else
			sampAddChatMessage("Возможно фейк", -1)
		end
		local coordinates = {data.position}
		local city = getCityFromCoords(coordinates[1], coordinates[2], coordinates[3])
		local name = sampGetCurrentServerName()
		local citys = {
			[0] = "Неизвестное место",
			[1] = "Лос Сантос",
			[2] = "Сан Фиерро",
			[3] = "Лас Вентурас"
		}
		if mode == 1 then
			SendVkNotification("Сервер: " ..name.. "\n (&#10071;) Найден клад!\n /setmarker " ..math.floor(data.position.x)..", " ..math.floor(data.position.y)..", " ..math.floor(data.position.z).. "\n Город: " ..citys[city].."\n Fake: "..fake)
		else
			sendTelegramNotification("Сервер: " ..name.. "\n Найден клад!\n /setmarker " ..math.floor(data.position.x)..", " ..math.floor(data.position.y)..", " ..math.floor(data.position.z).. "\n Город: " ..citys[city].."\n Fake: "..fake)
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

function autoupdate(json_url, prefix, url)
	local dlstatus = require('moonloader').download_status
	local json = getWorkingDirectory() .. '\\'..thisScript().name..'-version.json'
	if doesFileExist(json) then os.remove(json) end
	downloadUrlToFile(json_url, json,
	  function(id, status, p1, p2)
		if status == dlstatus.STATUSEX_ENDDOWNLOAD then
		  if doesFileExist(json) then
			local f = io.open(json, 'r')
			if f then
			  local info = decodeJson(f:read('*a'))
			  updatelink = info.updateurl
			  updateversion = info.latest
			  f:close()
			  os.remove(json)
			  if updateversion ~= thisScript().version then
				lua_thread.create(function(prefix)
				  local dlstatus = require('moonloader').download_status
				  local color = -1
				  sampAddChatMessage((prefix..'Обнаружено обновление. Пытаюсь обновиться c '..thisScript().version..' на '..updateversion), color)
				  wait(250)
				  downloadUrlToFile(updatelink, thisScript().path,
					function(id3, status1, p13, p23)
					  if status1 == dlstatus.STATUS_DOWNLOADINGDATA then
						print(string.format('Загружено %d из %d.', p13, p23))
					  elseif status1 == dlstatus.STATUS_ENDDOWNLOADDATA then
						print('Загрузка обновления завершена.')
						sampAddChatMessage((prefix..'Обновление завершено!'), color)
						goupdatestatus = true
						lua_thread.create(function() wait(500) thisScript():reload() end)
					  end
					  if status1 == dlstatus.STATUSEX_ENDDOWNLOAD then
						if goupdatestatus == nil then
						  sampAddChatMessage((prefix..'Обновление прошло неудачно. Запускаю устаревшую версию..'), color)
						  update = false
						end
					  end
					end
				  )
				  end, prefix
				)
			  else
				update = false
				print('v'..thisScript().version..': Обновление не требуется.')
			  end
			end
		  else
			print('v'..thisScript().version..': Не могу проверить обновление. Смиритесь или проверьте самостоятельно на '..url)
			update = false
		  end
		end
	  end
	)
	while update ~= false do wait(100) end
end
