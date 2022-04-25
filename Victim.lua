script_author("Diplo")
require 'lib.moonloader'
local sampev = require 'lib.samp.events'

function main()
while not isSampAvailable() do wait(200) end
x, y = getScreenResolution()
font = renderCreateFont("Arial", 9, 12)
color = 4281519410
	while true do
    	wait(0)
      if sampev.onServerMessage then
      if isKeyDown(VK_RBUTTON) and getCurrentCharWeapon(PLAYER_PED) == 34 then
        ax = x/2
        ay = y/2
        local x1, y1, z1 = convertScreenCoordsToWorld3D(ax, ay, 1.0)
        local x2, y2, z2 = convertScreenCoordsToWorld3D(ax, ay, 1000.0)
        result, data = processLineOfSight(x1, y1, z1, x2, y2, z2, false, true, true)
        if result and data and not isKeyDown(119) then
          if data.entityType == 3 and sampGetPlayerIdByCharHandle(getCharPointerHandle(data.entity)) then
            local id, distance = getPlayerInfo(getCharPointerHandle(data.entity))
            if id == victimId and getCharPointerHandle(data.entity) ~= 1 and not isKeyDown(VK_LBUTTON)  then
              renderFontDrawText(font,string.format("Это цель!\nДистанция: %d", distance) ,x/1.9, y/2.3, color)
            end
          elseif data.entityType == 2 and pcall(getVehiclePointerHandle, data.entity) then
            vhandle = getVehiclePointerHandle(data.entity)
            local pasSeats = getMaximumNumberOfPassengers(vhandle)
            if pcall(getDriverOfCar, vhandle) and getDriverOfCar(vhandle) ~= -1 and getDriverOfCar(vhandle) ~= 1 then
              local id, distance = getPlayerInfo(getDriverOfCar(vhandle))
              if id == victimId and getDriverOfCar(vhandle) ~= -1 and not isKeyDown(VK_LBUTTON) then
                renderFontDrawText(font,string.format("Цель: водитель\nДистанция: %d", distance) ,x/1.9, y/2.3, color)
              end
            end
            local counter = 0
            for val = 0, pasSeats do
              if pcall(getCharInCarPassengerSeat, vhandle, val) and getCharInCarPassengerSeat(vhandle, val) > 1 then
                local id, distance = getPlayerInfo(getCharInCarPassengerSeat(vhandle, val))
                if id == victimId and not isKeyDown(VK_LBUTTON) then
                  renderFontDrawText(font,string.format("Цель: пассажир %d\nДистанция: %d", val + 1, distance) ,x/1.9, y/2.3, color)
                end
                counter = counter + 1
              end
            end
          end
        end
		  end
    end
  end
end

function getPlayerInfo(handle)
  local resid, id = sampGetPlayerIdByCharHandle(handle)
  local distance = getDistance(handle)
  return id, distance
end

function getDistance(handle)
  local x, y, z = getCharCoordinates(PLAYER_PED)
  local mX, mY, mZ = getCharCoordinates(handle)
  dist = getDistanceBetweenCoords3d(x, y, z, mX, mY, mZ)
  return dist
end

function sampev.onServerMessage(color, text)
  local resid, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
  local name = sampGetPlayerNickname(id)
  if text:match(".* взяла? контракт на ликвидацию .*%[%d+%]") then
    tname, victimId = text:match("(.*) взяла? контракт на ликвидацию .*%[(%d+)%]")
    victimId = tonumber (victimId)
    if tname == name then
      return true
    end
  end
  if text:match(".* выполнила? заказ на .*%[%d+%]") then
    local tname = text:match("(.*) выполнила? заказ на .*%[(%d+)%]")
    if tname == name then
      return false
    end
  end
  if text:match(".* вернула? контракт на ликвидацию .*%[%d+%]") then
    local tname = text:match("(.*) вернула? контракт на ликвидацию .*%[%d+%]")
    if tname == name then
      return false
    end
  end
  if text:match("Твоя цель покинула сервер.") then
    return false
  end
end