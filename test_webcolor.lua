require('x_webcolor')

function print_color(name,color,valid)
  if (valid) then
    local pass = tostring(color) == string.lower("#"..valid)
    if pass then pass = "PASS" else pass = "FAIL" end
    print(name .. ": " .. tostring(color) .. " (should be: #" .. valid .. ") " .. pass)
    print()
  else
    print(name .. ": " .. tostring(color))
  end
end

a = Color()
print_color(" A", a, "000000FF")

a = Color("fff")
print_color(" A", a, "FFFFFFFF")

a = Color("08f8")
print_color(" A",a, "0088ff88")
b = Color("F80")
print_color(" B",b, "FF8800FF")
print("A + B = C")
c = a + b
print_color(" C", c, "FFFFFF88")

print("A - B = C")
c = a - b
print_color(" C", c, "0000FF88")

print("B - A = C")
c = b - a
print_color(" C", c, "FF0000FF")

c = -c
print_color("-C", c, "00FFFFFF")

a = -a
print_color("-A", a, "FF770088")

b = -b
print_color("-B", b, "0077FFFF")

d = Color(128,128,128)
print_color(" D", d, "808080FF")
d = -d
print_color("-D", d, "808080FF")

d = Color("abcdef")
print_color(" D", d, "ABCDEFFF")
d = -d
print_color("-D", d, "F0CEAAFF")

d = Color()
print_color(" D", d, "000000FF")

d = Color(100,200,100,128)
print_color(" D", d, "64C86480")
