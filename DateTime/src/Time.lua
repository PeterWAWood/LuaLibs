-- © Copyright 2017 Peter W A Wood
local Time = {}

Time.hour = 0
Time.minute = 0
Time.second = 0
Time.millisecond = 0

function Time:new (o)
  o = o or {}   -- create object if user does not provide one
  setmetatable(o, self)
  self.__index = self
  return o
end

function Time:moldHMS ()
  local second = self.second
  if self.millisecond > 499 then second = second + 1 end
  return string.format('%d', self.hour) .. ':' ..
         string.format('%02d', self.minute) .. ':' ..
         string.format('%02d', second)
end

Time.fromSeconds = function (secs)
  local t = {} 
  local remD
  local remH
  local remS
  remH = secs % 3600
  t.hour = (secs - remH) / 3600
  remM = remH % 60
  t.minute = (remH - remM) / 60
  remS = remM % 1
  t.second = remM - remS
  t.millisecond = remS * 1000
  return Time:new(t)
end 

return Time