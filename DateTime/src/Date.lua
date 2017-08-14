-- © Copyright 2017 Peter W A Wood
package.path = package.path .. ';./?.lua;'
local Time = require 'Time'
local Zone = require 'Zone'

local dateMonths = {Jan = 1, Feb = 2, Mar = 3, Apr = 4, May = 5, Jun = 6,
                    Jul = 7, Aug = 8, Sep = 9, Oct = 10, Nov = 11, Dec = 12} 

local Date = {}
Date.year = 0
Date.month = 0
Date.day = 0
Date.time = Time:new()
Date.zone = Zone:new()
                    
function Date:new (o)
  o = o or {}   -- create object if user does not provide one
  setmetatable(o, self)
  self.__index = self
  return o
end
                                        
Date.difference = function(a, b)
-- doesn't cope with half-hour and quarter-hour time zones
-- only works for same month
  local timeInSecs = function (d) 
    return (d.time.hour * 3600) + (d.time.minute * 60) + d.time.second +
            (d.time.millisecond / 1000) + (d.zone.hour * 3600) 
  end
  local aSecs = timeInSecs(a) + ((a.day - b.day) * 24 * 3600)
  local bSecs = timeInSecs(b)  
  return aSecs - bSecs
end

Date.fromRebol = function (rebolDate)
-- This should be refactored to use LPEG
  local take = function (s, l) 
    return rebolDate:sub(s, s + l - 1)
  end
  local takeNumber = function (s, l) 
    return tonumber(take(s, l))
  end
  local date = {
    time = Time:new(),
    zone = Zone:new()
  }
  local dateStart = 1
  local timeStart = rebolDate:find('/') + 1
  local zoneStart = rebolDate:find('+') 
  local dayLength = rebolDate:find('-') - 1
  local monthStart = dateStart + dayLength + 1
  local yearStart = monthStart + 4
  local hourLength = rebolDate:find(':', timeStart) - timeStart
  local minuteStart = timeStart + hourLength + 1
  local secondStart = minuteStart + 3
  local millisecondStart = secondStart + 3
  local millisecondLength = rebolDate:find('+') - millisecondStart
  local zoneHourlength = rebolDate:find(':', zoneStart) - zoneStart
  local zoneMinuteStart = zoneStart + zoneHourlength + 2
  date.year = takeNumber(yearStart, 4)
  date.month = dateMonths[take(monthStart, 3)]
  date.day = takeNumber(1, dayLength)
  date.time.hour = takeNumber(timeStart, hourLength)
  date.time.minute = takeNumber(minuteStart, 2)
  date.time.second = takeNumber(secondStart, 2)
  date.time.millisecond = takeNumber(millisecondStart, millisecondLength)
  date.zone.hour = takeNumber(zoneStart, zoneHourlength)
  date.zone.minute = takeNumber(zoneMinuteStart, 2)
  return date
end

return Date