--[[
  x_webcolor.lua
  v0.1 -- FEB-18-2011
 
  Copyright © 2011 Ben Sharpe (me@bsharpe.com / http://bsharpe.com).
  All Rights Reserved.

  Permission is hereby granted, free of charge, to any person 
  obtaining a copy of this software to deal in the Software without 
  restriction, including without limitation the rights to use, 
  copy, modify, merge, publish, distribute, sublicense, and/or 
  sell copies of the Software, and to permit persons to whom the 
  Software is furnished to do so, subject to the following conditions:

  The above copyright notice and this permission notice shall be 
  included in all copies or substantial portions of the Software.
  If you find this software useful please give www.chipmunkav.com a mention.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, 
  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES 
  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
  IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR 
  ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF 
  CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN 
  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
  
  ---------------
  Usage:
      require 'x_webcolor'
      
      a = Color()           -- a is black
      b = Color("888")      -- b is gray
      c = a + b             -- c is gray ("888888") because "000" + "888" = "888"
      c = b + b             -- c is white ("fff")   because "888" + "888" = "fff" (actually, it's '1110', but it clips it to 'FFF' the maximum color value)
      
      a = Color(255,255,255) -- alternative way using ints, yuk.
      
      a = Color("F00")      -- red
      b = Color("00F")      -- blue
      c = a + b             -- purple "F0F"
      d = c - b             -- back to red "F0F" - "00F" = "F00"
      
      a = Color("4daca4")   -- a is now a sort of blue/green color
      local rect = display.newRect(0,0,10,100)
      a:setFillColorOn(rect)  -- rect is now blue/green
      
      b = -a                  -- b is now the 'opposite' color of a (based on the color wheel)
      b:setFillColorOn(rect)  -- rect is now the opposite color 
      
      a:setFillColorOn(rect)   -- back to blue/green
      b = a - Color("222")     -- make 'a' a little darker
      b:setStrokeColorOn(rect) -- now the rect has a slightly darker border color
      
  Color Codes:
      Color() can take 3,4,6 or 8 character codes in the form:
        RGB
        RGBA
        RRGGBB
        RRGGBBAA
      where A is the alpha of the color, if no Alpha is specified then it's 255 (or completely opaque)
      
      Use your favorite HTML color tool to find good colors.
]]

require('lib_class')

Color = class()
Color.version = 1.0

----------------------------------------------------------------------------------------------------
----									LOCALISED VARIABLES										----
----------------------------------------------------------------------------------------------------

local ssub = string.sub
local slen = string.len
local supp = string.upper
local slow = string.lower
local sfmt = string.format
local print = print
local type = type
local tonumber = tonumber
local assert = assert
local mMax = math.max
local mMin = math.min
local round = function(num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end

----------------------------------------------------------------------------------------------------
----									PUBLIC METHODS											----
----------------------------------------------------------------------------------------------------
function Color:init(...)
  -- You can either supply a hexstring as the starting color value
  -- or 3 or 4 parameters (r,g,b[,a])
  -- If no parameters are supplied then the color defaults to black
  if (#arg == 1) then
    self:set(arg[1])
  elseif( #arg == 4 or #arg == 3) then
    local r = mMax(0, mMin(255, arg[1]))
    local g = mMax(0, mMin(255, arg[2]))
    local b = mMax(0, mMin(255, arg[3]))
    local a = mMax(0, mMin(255, arg[4] or 255))
    self.r, self.g, self.b, self.a = r,g,b,a
  elseif (#arg == 0) then
    self.r, self.g, self.b, self.a = 0,0,0,255 -- black
  end
end

function Color:set(colorstr)
  -- Set the Color to a new value based on the string supplied
  assert(colorstr, "Missing color value")
  assert(type(colorstr) == "string", "Color:set() expects a string to set the color to e.g. 'FF00FF'")
  local len = slen(colorstr)
  assert(len == 3 or len == 4 or len == 6 or len == 8, "Invalid length for color string. 3,4,6 or 8 expected.")

  -- always convert input to 8 uppcase hex digits (RRGGBBAA)
  colorstr = supp(colorstr)
  if (len == 3 or len == 4) then
    local c1 = ssub(colorstr,1,1)
    local c2 = ssub(colorstr,2,2)
    local c3 = ssub(colorstr,3,3)
    local c4 = "F"
    if (len == 4) then c4 = ssub(colorstr,4,4) end
    colorstr = c1 .. c1 .. c2 .. c2 .. c3 .. c3 .. c4 .. c4
  elseif len == 6 then
    colorstr = colorstr .. 'FF'
  end

  self.r = tonumber(ssub(colorstr, 1,2), 16)
  self.g = tonumber(ssub(colorstr, 3,4), 16)
  self.b = tonumber(ssub(colorstr, 5,6), 16)
  self.a = tonumber(ssub(colorstr, 7,8), 16)
end

function Color:to_a()
  -- convert the color to a table of 4 values
  return { self.r, self.g, self.b, self.a }
end

function Color:__add(b)
  local c = Color()
  c.r = self.r + b.r
  c.g = self.g + b.g
  c.b = self.b + b.b
  c.a = self.a
  if c.r > 255 then c.r = 255 end
  if c.g > 255 then c.g = 255 end
  if c.b > 255 then c.b = 255 end
  if c.a > 255 then c.a = 255 end
  return c
end

function Color:__sub(b) 
  local c = Color()
  c.r = self.r - b.r
  c.g = self.g - b.g
  c.b = self.b - b.b
  c.a = self.a
  if c.r < 0 then c.r = 0 end
  if c.g < 0 then c.g = 0 end
  if c.b < 0 then c.b = 0 end
  if c.a < 0 then c.a = 0 end
  return c
end
  
function Color:__eq(b)
  -- NOTE: We're not comparing alpha channels to find equality
  return ((self.r == b.r) and (self.g == b.g) and (self.b == b.b))
end

function Color:__unm()
  -- Returns the opposite color (on the color wheel)
  -- NOTE: Alpha channel is set to the value of the original color
  local h,s,v = self:to_hsv()
  h = h + 180
  if (h > 360) then h = h - 360 end
  return Color():from_hsv(h,s,v,self.a)
end

function Color:__tostring()
  return slow(sfmt("#%02X%02X%02X%02X", self.r, self.g, self.b, self.a))
end

function Color:to_hsv()
  -- return the current color as HSV values
  -- h = 0 to 360
  -- s = 0 to 100
  -- v = 0 to 100
  local h, s, v
  local r, g, b = round(self.r / 255.0,2), round(self.g / 255.0, 2), round(self.b / 255.0, 2)
  
  local min = mMin(r, g, b)
  local max = mMax(r, g, b)

  v = round(max * 100)
  if (max == min) then
    -- achromatic, you know, it's gray
    s,h = 0,0
  else
    local delta = max - min
    s = round((delta / max) * 100)
    if (r == max) then
      h = (g - b) / delta
    elseif (g == max) then
      h = 2 + (b - r) / delta
    else
      h = 4 + (r - g) / delta
    end
    h = round(h * 60)
    if (h < 0) then
      h = h + 360
    end
  end
  return h,s,v
end

function Color:from_hsv(h,s,v,a)
  -- set this colors r,g,b based on the hue, saturation and value
  -- 0 < h < 360
  -- 0 < s < 100
  -- 0 < v < 100
  -- a is alpha [unchanged]
  assert( h, "Hue required" )
  assert( v, "Value required" )
  assert( s, "Saturation required" )
  
  local h = mMax(0, mMin(360, h))
  local s = mMax(0, mMin(100, s))
  local v = mMax(0, mMin(100, v))
  local a = a or self.a
  
  s = s / 100.0
  v = v / 100.0
  
  if (s == 0) then
    -- achromatic
    self.r, self.g, self.b = v,v,v
  else
    h = h / 60
    local i = math.floor(h)
    local f = h - i
    local p = v * (1 - s)
    local q = v * (1 - s * f)
    local t = v * (1 - s * (1 - f))

    if (i == 0) then
      self.r, self.g, self.b = v, t, p
    elseif (i == 1) then
      self.r, self.g, self.b = q, v, p
    elseif (i == 2) then
      self.r, self.g, self.b = p, v, t
    elseif (i == 3) then
      self.r, self.g, self.b = p, q, v
    elseif (i == 4) then
      self.r, self.g, self.b = t, p, q
    elseif (i == 5) then
      self.r, self.g, self.b = v, p, q
    end
  end
  self.r = round(self.r * 255)
  self.g = round(self.g * 255)
  self.b = round(self.b * 255)  
  self.a = a
  
  return self
end


    
-- some handy utility functions for setting the color of things
-- if only setTextColor (and the API in general) would use a table of 4 values
-- as colors instead of 4 separate parameters...

function Color:setTextColorOn(obj)
  assert(obj, "Object is nil")
  obj:setTextColor(self.r,self.g,self.b,self.a)
end

function Color:setStrokeColorOn(obj)
  assert(obj, "Object is nil")
  obj:setStrokeColor(self.r,self.g,self.b,self.a)
end

function Color:setFillColorOn(obj)
  assert(obj, "Object is nil")
  obj:setFillColor(self.r,self.g,self.b,self.a)
end

function Color:setColorOn(obj)
  assert(obj, "Object is nil")
  obj:setColor(self.r,self.g,self.b,self.a)
end


