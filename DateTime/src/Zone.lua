-- © Copyright 2017 Peter W A Wood
local Zone = {}

Zone.hour = 0
Zone.minute = 0

function Zone:new (o)
  o = o or {}   -- create object if user does not provide one
  setmetatable(o, self)
  self.__index = self
  return o
end

return Zone