script_author('olol321 & ������')
script_version('1.5')
local msg = ""
local tag = '����������: '


-----[��� ������ ���������!]
token_vk = '' --����� ������
chat_id = '' --�� ������, ������ 1(���� � ������ ������� ����� 1 ������ �� ������ 1, ����� ����� ���� ���� ������ ������, �������� �� ������ � ������, � ����� ������ � ������)
groupid_vk = '' --�� ������(�� ���������)
--[��� ������ ���������!]
chat_idtg = '' -- ��� ID �����
token_tg = '' -- ����� ���� ��
------
mode = 1 ---���� ��� 1 �� ��, ���� 2 �� ��������





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
	sampAddChatMessage(tag..'������� ��������', -1)
	sampAddChatMessage('�����: vk.com/beschastnov123 & ������', -2)
	
	if mode == 1 then
	sampAddChatMessage("������� ����� 1 (���������)", 0xFFFF0000)
	SendVkNotification("(&#10071;) ������� ����� �� ������!\n������ ������ ������...")
	else
	sampAddChatMessage("������� ����� 2 (��������)", 0xFFFF0000)
	sendTelegramNotification('������� ����� �� ������!\n������ ������ ������...')
	end

    while true do 
        wait(1)
		--��� ���� ��������� Server closed the connection ��� You are banned from this server �� �������� ��������� � ��
		local chatstring = sampGetChatString(99)
        if chatstring == "Server closed the connection." or chatstring == "You are banned from this server." then
		sampDisconnectWithReason(false)
			--wait(1000)
			if mode == 1 then
			SendVkNotification('������� ����� � �������, �������: ���/��� \n *������ ��������� ���������(���� ������ ���, ������ ������� � �������)')
			else
			sendTelegramNotification('������� ����� � �������, �������: ���/��� \n *������ ��������� ���������(���� ������ ���, ������ ������� � �������)')
			end
		end
		--wait(-1)
		end
end

--[���� � ���� ���������� ��������� ���������� � ���� ������������� � ��� ���, �� ��� ���������� � �� ���������]
function sampev.onServerMessage(color, text)  
    local _, idd = sampGetPlayerIdByCharHandle(PLAYER_PED)
    if text:find('�������������') and (sampIsPlayerConnected(id) and text:find(sampGetPlayerNickname(idd))) then
		msg = text:gsub("{......}", "")
		if mode == 1 then
		SendVkNotification('(&#10071;) ������� ��� ������ ! �������: ������ 228 �� ��. [���] \n\n' ..msg)
		else
		sendTelegramNotification('������� ��� ������ ! �������: ������ 228 �� ��. [���] \n\n' ..msg)
		end
    end
end

function sampev.onCreateObject(objectId, data)
    if data.modelId == 1271 then --1271
        sampAddChatMessage(tag..'�������� ����: '..data.position.x..' '..data.position.y..' '..data.position.z, -1)
		sampProcessChatInput('/mpos' ..data.position.xx..' '..data.position.xy..' '..data.position.xz)
		sampAddChatMessage('�������� ����� �� ����������: ' ..data.position.xx..' '..data.position.xy..' '..data.position.xz)
		
		ip, port = sampGetCurrentServerAddress()
		name = sampGetCurrentServerName()
		sampAddChatMessage(name, 0xFFFF0000)
		
		xx = data.position.x
		xy = data.position.y
		xz = data.position.z
		vms = math.floor(xx)..", "..math.floor(xy)..", "..math.floor(xz)
		gor = getCityFromCoords(xx, xy, xz)
		if gor == 1 then
		gorod = '��� ������'	
		end
		if gor == 2 then
		gorod = '��� ������'	
		end
		if gor == 3 then
		gorod = '��� ��������'	
		end
		if gor == 0 then
		gorod = '����������� �����'	
		end
			
		if mode == 1 then
		SendVkNotification("������: " ..name.. "\n (&#10071;) ������ ����!\n /setmarker " ..math.floor(data.position.x)..", " ..math.floor(data.position.y)..", " ..math.floor(data.position.z).. "\n �����: " ..gorod)
		else
		sendTelegramNotification("������: " ..name.. "\n ������ ����!\n /setmarker " ..math.floor(data.position.x)..", " ..math.floor(data.position.y)..", " ..math.floor(data.position.z).. "\n �����: " ..gorod)
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

------��� ���� �������� ���������
function sendTelegramNotification(msgtg) -- ������� ��� �������� ��������� �����
    msgtg = msgtg:gsub('{......}', '') --��� ���� ������� ����
    msgtg = encodeUrl(msgtg) -- �� ��� �� ���������� ������
	sampAddChatMessage("���������� ��������� � ��������...", 0xFFFF0000)
    async_http_request('https://api.telegram.org/bot' .. token_tg .. '/sendMessage?chat_id=' .. chat_idtg .. '&text='..msgtg,'', function(result) end) -- � ��� ��� ��������
end

function SendVkNotification(msgvk) -- ������� ��� �������� ��������� �����
    sampAddChatMessage("���������� ��������� � ���������...", 0xFFFF0000)
	requests.get("https://api.vk.com/method/messages.send?v=5.103&access_token="..token_vk.."&chat_id="..chat_id.."&message="..urlencode(u8:encode(msgvk, 'CP1251')).."&group_id="..groupid_vk.."&random_id="..random(1111111111, 9999999999))
end
