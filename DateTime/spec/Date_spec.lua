package.path = package.path .. ';../src/?.lua;'
require 'busted.runner'()
local lfs = require 'lfs'
local dateTime = require 'Date'

describe('canary test', function ()
 it('should pass a simple test', function ()
      assert.is_true(true)
  end)
end)
  
describe('fromRebol', function ()
  it('should import 12-Aug-2017/8:56:56.835+8:00', function ()
    local d = dateTime.fromRebol '12-Aug-2017/8:56:56.835+8:00'
    assert.equal(2017, d.year)
    assert.equal(8, d.month)
    assert.equal(12, d.day)
    assert.equal(8, d.time.hour)
    assert.equal(56, d.time.minute)
    assert.equal(56, d.time.second)
    assert.equal(835, d.time.millisecond)
    assert.equal(8, d.zone.hour)
    assert.equal(0, d.zone.minute)
  end)
  it('should import 1-Aug-2017/18:56:56.835+08:00', function ()
    local d = dateTime.fromRebol '1-Aug-2017/18:56:56.835+08:00'
    assert.equal(2017, d.year)
    assert.equal(8, d.month)
    assert.equal(1, d.day)
    assert.equal(18, d.time.hour)
    assert.equal(56, d.time.minute)
    assert.equal(56, d.time.second)
    assert.equal(835, d.time.millisecond)
    assert.equal(8, d.zone.hour)
    assert.equal(0, d.zone.minute)
  end)
  it('should import 1-Aug-2017/8:56:56.835+08:00', function ()
    local d = dateTime.fromRebol '1-Aug-2017/8:56:56.835+08:00'
    assert.equal(2017, d.year)
    assert.equal(8, d.month)
    assert.equal(1, d.day)
    assert.equal(8, d.time.hour)
    assert.equal(56, d.time.minute)
    assert.equal(56, d.time.second)
    assert.equal(835, d.time.millisecond)
    assert.equal(8, d.zone.hour)
    assert.equal(0, d.zone.minute)
  end)
  it('should import 18-Aug-2017/18:56:56.835+08:00', function ()
    local d = dateTime.fromRebol '18-Aug-2017/18:56:56.835+08:00'
    assert.equal(2017, d.year)
    assert.equal(8, d.month)
    assert.equal(18, d.day)
    assert.equal(18, d.time.hour)
    assert.equal(56, d.time.minute)
    assert.equal(56, d.time.second)
    assert.equal(835, d.time.millisecond)
    assert.equal(8, d.zone.hour)
    assert.equal(0, d.zone.minute)
  end)
end)

describe('difference', function ()
  it('should return 0 if the dates are equal', function ()
    local d = {
      year = 2017, month = 8, day = 12,
      time = {hour = 8, minute = 56, second = 56, millisecond = 835},
      zone = {hour = 8, minute = 0}
    }
    assert.equal(0, dateTime.difference(d, d))
  end)
  it('should return 1 for two date one second apart on the same day', function ()
    local d = {
      year = 2017, month = 8, day = 12,
      time = {hour = 8, minute = 56, second = 56, millisecond = 835},
      zone = {hour = 8, minute = 0}
    }
    local e = {
      year = 2017, month = 8, day = 12,
      time = {hour = 8, minute = 56, second = 57, millisecond = 835},
      zone = {hour = 8, minute = 0}
    }
    assert.equal(1, dateTime.difference(e, d))
  end)
  it('should return less than 1 for two date less than one second', function ()
    local d = {
      year = 2017, month = 8, day = 12,
      time = {hour = 8, minute = 56, second = 56, millisecond = 835},
      zone = {hour = 8, minute = 0}
    }
    local e = {
      year = 2017, month = 8, day = 12,
      time = {hour = 8, minute = 56, second = 57, millisecond = 335},
      zone = {hour = 8, minute = 0}
    }
    assert.equal(0.5, dateTime.difference(e, d))
  end)
  it('should calculate the difference between times on the same day', function ()
    local d = dateTime.fromRebol('5-Aug-2017/21:13:37.793+8:00')
    local e = dateTime.fromRebol('5-Aug-2017/23:49:12.016+8:00')
    assert.equal('9334.223', tostring(dateTime.difference(e, d)))
  end)
  it('should calculate the difference between different days in the same month', function ()
    local d = dateTime.fromRebol('26-Jul-2017/17:37:20.242+8:00')
    local e = dateTime.fromRebol('27-Jul-2017/7:25:10.032+8:00')
    assert.equal('49669.79', tostring(dateTime.difference(e, d)))
  end)
end)
