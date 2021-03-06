package.path = package.path .. ';../src/?.lua;'
require 'busted.runner'()
local lfs = require 'lfs'
local Time = require 'Time'

describe('canary test', function ()
 it('should pass a simple test', function ()
      assert.is_true(true)
  end)
end)
  
describe('fromSeconds', function ()
  it('should correctly convert 0 seconds', function () 
    local t = Time.fromSeconds(0)
    assert.equal(0, t.hour)
    assert.equal(0, t.minute)
    assert.equal(0, t.second)
    assert.equal(0, t.millisecond)
  end)
  it('should correctly convert 1 second', function ()
    local t = Time.fromSeconds(1) 
    assert.equal(0, t.hour)
    assert.equal(0, t.minute)
    assert.equal(1, t.second)
    assert.equal(0, t.millisecond)
  end)
  it('should correctly convert 100 milliseconds', function () 
    local t = Time.fromSeconds(0.100)
    assert.equal(0, t.hour)
    assert.equal(0, t.minute)
    assert.equal(0, t.second)
    assert.equal(100, t.millisecond)
  end)
  it('should correctly convert 25 hours 24 minutes 35 seconds', function () 
    local t = Time.fromSeconds((25 * 3600) + (24 * 60) + 35)
    assert.equal(25, t.hour)
    assert.equal(24, t.minute)
    assert.equal(35, t.second)
    assert.equal(0, t.millisecond)
  end)
end)

describe('moldHMS', function () 
  it('should return 0:00:00 for 0', function ()
    local t = Time.fromSeconds(0)
    assert.equal('0:00:00', t:moldHMS())
  end)
  it('should return 25:24:36 for 25 hours 24 minutes 35 seconds 500 milliseconds', function ()
    local t = Time.fromSeconds((25 * 3600) + (24 * 60) + 35.500)
    assert.equal('25:24:36', t:moldHMS())
  end)
end)