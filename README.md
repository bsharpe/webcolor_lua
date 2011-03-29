# webcolor_lua

Coming from an HTML background, I find it much easier to think of colors in terms of CSS color codes (e.g. #fff, #909, etc.) than decimal numbers.

So, this little utility class allows one to use their current CSS color brains in their CoronaSDK projects.

## Usage:
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
    
## Color Codes:
Color() can take 3,4,6 or 8 character codes in the form:

    RGB
    RGBA
    RRGGBB
    RRGGBBAA
    
where A is the alpha of the color, if no Alpha is specified then it's 255 (or completely opaque)

Use your favorite HTML color tool to find good colors.  There's a nice cheatsheet included.

_CheatSheet courtesy of:_ [a coding fool](http://blog.acodingfool.com/cheatsheets/html-colors-cheatsheet/)

## How to add it to your project
   
    >git clone git@github.com:bsharpe/webcolor_lua.git
    
then copy the files: lib_class.lua and x_webcolor.lua into your project.

or you can click on the **Downloads** button up at the top and get a compressed package of the files.
