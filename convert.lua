local T = {
  a = "あ", i = "い", u = "う", e = "え", o = "お",
  ka = "か", ki = "き", ku = "く", ke = "け", ko = "こ",
}

local chunks = {"a", "o", "i"}
local result = ""

for _, chunk in ipairs(chunks) do
    result = result .. T[chunk]
end

print(result)
