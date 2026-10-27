local T = {
    a = "あ", i = "い", u = "う", e = "え", o = "お",

    ka = "か", ki = "き", ku = "く", ke = "け", ko = "こ",
    sa = "さ", si = "し", su = "す", se = "せ", so = "そ",
    ta = "た", ti = "ち", tu = "つ", te = "て", to = "と",
    na = "な", ni = "に", nu = "ぬ", ne = "ね", no = "の",
    ha = "は", hi = "ひ", hu = "ふ", he = "へ", ho = "ほ",
    ma = "ま", mi = "み", mu = "む", me = "め", mo = "も",
    ya = "や",            yu = "ゆ",            yo = "よ",
    ra = "ら", ri = "り", ru = "る", re = "れ", ro = "ろ",
    wa = "わ", wi = "うぃ", we = "うぇ", wo = "を",
    n = "ん",

    ga = "が", gi = "ぎ", gu = "ぐ", ge = "げ", go = "ご",
    za = "ざ", zi = "じ", zu = "ず", ze = "ぜ", zo = "ぞ",
    da = "だ", di = "ぢ", du = "づ", de = "で", ["do"] = "ど",
    ba = "ば", bi = "び", bu = "ぶ", be = "べ", bo = "ぼ",
    pa = "ぱ", pi = "ぴ", pu = "ぷ", pe = "ぺ", po = "ぽ",

    shi = "し", chi = "ち", tsu = "つ", fu = "ふ",
    ji = "じ", ja = "じゃ", ju = "じゅ", je = "じぇ", jo = "じょ",

    kya = "きゃ", kyu = "きゅ", kyo = "きょ",
    sha = "しゃ", shu = "しゅ", she = "しぇ", sho = "しょ",
    cha = "ちゃ", chu = "ちゅ", che = "ちぇ", cho = "ちょ",
    nya = "にゃ", nyu = "にゅ", nyo = "にょ",
    hya = "ひゃ", hyu = "ひゅ", hyo = "ひょ",
    mya = "みゃ", myu = "みゅ", myo = "みょ",
    rya = "りゃ", ryu = "りゅ", ryo = "りょ",
    gya = "ぎゃ", gyu = "ぎゅ", gyo = "ぎょ",
    bya = "びゃ", byu = "びゅ", byo = "びょ",
    pya = "ぴゃ", pyu = "ぴゅ", pyo = "ぴょ",

    sya = "しゃ", syu = "しゅ", syo = "しょ",
    tya = "ちゃ", tyu = "ちゅ", tyo = "ちょ",
    zya = "じゃ", zyu = "じゅ", zyo = "じょ",
    jya = "じゃ", jyu = "じゅ", jyo = "じょ",
    dya = "ぢゃ", dyu = "ぢゅ", dyo = "ぢょ",

    fa = "ふぁ", fi = "ふぃ", fe = "ふぇ", fo = "ふぉ",
    tsa = "つぁ", tsi = "つぃ", tse = "つぇ", tso = "つぉ",
    thi = "てぃ", dhi = "でぃ", twu = "とぅ", dwu = "どぅ",
    va = "ゔぁ", vi = "ゔぃ", vu = "ゔ", ve = "ゔぇ", vo = "ゔぉ",

    xa = "ぁ", xi = "ぃ", xu = "ぅ", xe = "ぇ", xo = "ぉ",
    xya = "ゃ", xyu = "ゅ", xyo = "ょ",
    xtu = "っ", xwa = "ゎ",

    ["-"] = "ー",
}

local function convert(s)
    local result = ""
    local i = 1

    while i <= #s do
        local c         = s:sub(i, i)
        local nxt       = s:sub(i + 1, i + 1)
        local three     = s:sub(i, i + 2)
        if T[three] then
            result = result .. T[three]
            i = i + 3
            goto continue
        end
        local len

        if c == "n" then
            if nxt:match("[aeiouy]") then
                len = 2
            else
                len = 1
            end
        elseif c == nxt and c:match("[^aeiou %-]") then
            result = result .. "っ"
            i = i + 1
            goto continue
        elseif c:match("[aeiou %-]") then
            len = 1
        else
            len = 2
        end

        local chunk = s:sub(i, i + len - 1)
        result = result .. (T[chunk] or chunk)
        i = i + len
        ::continue::
    end

    return result
end

local function kata(s)
    local out = {}
    for _, cp in utf8.codes(s) do
        if cp >= 0x3041 and cp <= 0x3096 then
            cp = cp + 0x60
        end
        out[#out + 1] = utf8.char(cp)
    end
    return table.concat(out)
end

local function parse(rest)
    local list = {}
    for piece in rest:gmatch("[^/]+") do
        local cand = piece:match("^%s*([^;]+)")
        if cand and cand:sub(1, 1) ~= "(" then
            list[#list + 1] = cand
        end
    end
    return list
end

local function open_dict(path)
    local f = assert(io.open(path, "rb"))
    if not f then
        io.stderr:write("missing ", path, ": run fetch-dict.sh\n")
        os.exit(1)
    end
    return f, f:seek("end")
end

local function lookup(f, size, key)
    local lo, hi = 0, size
    while hi - lo > 4096 do
        local mid = (lo + hi) // 2
        f:seek("set", mid)
        f:read("l")
        local pos = f:seek()
        local line = f:read("l")
        if not line then
            hi = mid
        else
            local p = line:find(" /", 1, true)
            local k = line:sub(1, p - 1)
            if k < key then lo = pos else hi = mid end
        end
    end
    f:seek("set", lo)
    for line in f:lines() do
        local p = line:find(" /", 1, true)
        if p then
            local k = line:sub(1, p - 1)
            if k == key then return line:sub(p + 2) end
            if k > key then return nil end
        end
    end
end

local function candidates(hira, f, size)
    local list = {}
    local raw = lookup(f, size, hira)
    if raw then
        for _, c in ipairs(parse(raw)) do
            list[#list + 1] = c
        end
    end
    list[#list + 1] = hira
    list[#list + 1] = kata(hira)
    return list
end

local f, size = open_dict("okuri-nasi.txt")
local state = {mode = "typing", buf = "", cands = {}, idx = 1, out = ""}

local function display(st) 
    if st.mode == "converting" then
        return st.out .. "[" .. st.cands[st.idx] .. "]"
    end
    return st.out .. convert(st.buf)
end

local function handle_key(st, key) 
    if st.mode == "typing" then
        if key == "convert" then
            if st.buf == "" then return false end
            st.cands = candidates(convert(st.buf), f, size)
            st.idx = 1;
            st.mode = "converting"
        elseif key == "enter" then
            if st.buf == "" then return false end
            st.out = st.out .. convert(st.buf)
            st.buf = ""
        elseif key == "backspace" then
            if st.buf == "" then return false end
            st.buf = st.buf:sub(1, -2)
        elseif key == "left" or key == "right" then
            return st.buf ~= ""
        elseif #key == 1 then
            st.buf = st.buf .. key
        end
    else 
        if key == "convert" or key == "right" then
            st.idx = st.idx % #st.cands + 1
        elseif key == "left" then
            st.idx = (st.idx - 2) % #st.cands + 1
        elseif key == "enter" then
            st.out = st.out .. st.cands[st.idx]
            st.buf = ""
            st.mode = "typing"
        elseif key == "backspace" then
            st.mode = "typing"
        elseif #key == 1 then
            st.out = st.out .. st.cands[st.idx]
            st.buf = key;
            st.mode = "typing"
        end
    end
    return true
end

for token in io.read("a"):gmatch("%S+") do
    local used = handle_key(state, token)
    print(token, display(state), used and "" or "(pass)")
end

print("OUT: " .. state.out)
