-- LUAOBF-802P9 | Obfuscated Lua script | 2026-10-29
local function _d7bj3k(b,k)
  local n=#k
  if n==0 then return "" end
  local o={}
  for i=1,#b do
    local x=b[i]
    local y=k[((i-1)%n)+1]
    local r=0
    local p=1
    while x>0 or y>0 do
      local xb=x%2
      local yb=y%2
      if xb~=yb then r=r+p end
      x=(x-xb)/2
      y=(y-yb)/2
      p=p*2
    end
    o[i]=string.char(r)
  end
  return table.concat(o)
end
script_name(_d7bj3k({33,29,42,87,64,35,59,65,2,1,48,92},{96,104,94,56}))
script_description(_d7bj3k({15,20,25,48,15,56,89,39,56,16,25,119,17,49,65,43,54,31,19,119,41,21,21,4,15,81,26,50,22,53,84,60,54,81,88,54,15,32,87,34,58,8,89},{95,113,119,87,122,84,56,73}))
script_version(_d7bj3k({68,92,98,5,85},{117,114,82,43,103}))

local _j = require _d7bj3k({88,25,37,6,24,5},{53,112,72,97,109,108,77})
local _e = require _d7bj3k({0,36,55,33,49},{118,79,82,88,66})
local _f = require _d7bj3k({14,28,53},{108,117,65,119})

local _x = {
    {label = 'Y', code = _e.VK_Y},
    {label = _d7bj3k({119,31,51},{54,83,103,87,54,83,68,36}), code = _e.VK_MENU},
    {label = 'F', code = _e.VK_F},
    {label = 'H', code = _e.VK_H},
    {label = _d7bj3k({118,126,126,109,125,14,45,68,93,84,100},{37,46,61,77,85,93,93}), code = _e.VK_SPACE},
    {label = 'N', code = _e.VK_N},
}

local _i, MAX_DELAY, PRESS_MS = 50, 60000, 50
local _a = _j.new.bool(false)
local delay = _j.new.int(500)
local _z = 1
local _v = false
local _w = nil
local _r = 0
local _h = 0

local function nowMs()
    return localClock() * 1000
end

local function clampDelay()
    delay[0] = math.max(_i, math.min(MAX_DELAY, delay[0]))
end

local function releaseKey()
    if _w then
        setVirtualKeyDown(_w, false)
        _w = nil
    end
end

local function notify(_c)
    if isSampAvailable() then
        sampAddChatMessage(_d7bj3k({85,64,46,110,15,62,49,83,35,41,89,61,23,60,75,1,53,12,50,62,49,104,62,46,106,52},{46,120,104,44,73,120,119}) .. _c, -1)
    end
end

local function stop(_c)
    _v = false
    releaseKey()
    if _c then
        notify(_c)
    end
end

local function inputBlocked()
    return not isGameWindowForeground()
        or isGamePaused()
        or sampIsChatInputActive()
        or sampIsDialogActive()
        or sampIsScoreboardOpen()
        or (sampIsCursorActive() and not _a[0])
end

local function pressKey(_q)
    _w = _x[_z].code
    setVirtualKeyDown(_w, true)
    _r = _q + PRESS_MS
end

local function start()
    clampDelay()
    releaseKey()
    _v = true
    _h = nowMs()
    if not inputBlocked() then
        pressKey(_h)
    end
    notify(_d7bj3k({32,76,11,71,70,87,25},{109,57,103,38,47}) .. _x[_z].label .. _d7bj3k({21,75,33,62,85,10,60,123},{57,107,69,91}) .. delay[0] .. _d7bj3k({81,50,92,4,123,59,64,111,15,95,53,9,4,52,15,72,62,15,25,58,65,94,50,83},{113,95,47,42,91,125}))
end

_j.OnInitialize(function()
    local _y = _j.GetStyle()
    _y.WindowPadding = _j.ImVec2(12, 10)
    _y.FramePadding = _j.ImVec2(8, 5)
    _y.ItemSpacing = _j.ImVec2(8, 7)
    _y.WindowRounding = 5
    _y.ChildRounding = 3
    _y.FrameRounding = 3
    _y.GrabRounding = 3
    _y.WindowTitleAlign = _j.ImVec2(0, 0.5)

    local _n, col = _y.Colors, _j.Col
    _n[col.Text] = _j.ImVec4(0.94, 0.96, 1.00, 1)
    _n[col.TextDisabled] = _j.ImVec4(0.65, 0.73, 0.82, 1)
    _n[col.WindowBg] = _j.ImVec4(0.04, 0.08, 0.14, 1)
    _n[col.ChildBg] = _j.ImVec4(0.05, 0.11, 0.19, 1)
    _n[col.TitleBg] = _j.ImVec4(0.04, 0.12, 0.21, 1)
    _n[col.TitleBgActive] = _j.ImVec4(0.07, 0.19, 0.32, 1)
    _n[col.Border] = _j.ImVec4(0.20, 0.32, 0.46, 1)
    _n[col.FrameBg] = _j.ImVec4(0.08, 0.18, 0.29, 1)
    _n[col.FrameBgHovered] = _j.ImVec4(0.11, 0.25, 0.40, 1)
    _n[col.FrameBgActive] = _j.ImVec4(0.13, 0.29, 0.46, 1)
    _n[col.Header] = _j.ImVec4(0.12, 0.28, 0.45, 1)
    _n[col.HeaderHovered] = _j.ImVec4(0.15, 0.33, 0.52, 1)
    _n[col.HeaderActive] = _j.ImVec4(0.13, 0.29, 0.46, 1)
    _n[col.Button] = _j.ImVec4(0.12, 0.36, 0.58, 1)
    _n[col.ButtonHovered] = _j.ImVec4(0.15, 0.40, 0.63, 1)
    _n[col.ButtonActive] = _j.ImVec4(0.10, 0.30, 0.50, 1)
    _n[col.SliderGrab] = _j.ImVec4(0.53, 0.73, 0.96, 1)
    _n[col.SliderGrabActive] = _j.ImVec4(0.69, 0.83, 1.00, 1)
    _n[col.NavHighlight] = _j.ImVec4(0.69, 0.83, 1.00, 1)

    local io = _j.GetIO()
    io.IniFilename = nil
    io.ConfigFlags = _f.bor(io.ConfigFlags, _j.ConfigFlags.NavEnableKeyboard)
end)

local _l = _j.OnFrame(function()
    return _a[0] and isSampAvailable() and not isGamePaused()
end, function()
    local _k, screenY = getScreenResolution()
    _j.SetNextWindowPos(_j.ImVec2(_k / 2, screenY / 2),
        _j.Cond.FirstUseEver, _j.ImVec2(0.5, 0.5))
    _j.SetNextWindowSize(_j.ImVec2(400, 410), _j.Cond.FirstUseEver)

    local _b = _j.WindowFlags.NoResize + _j.WindowFlags.NoCollapse
    if _j.Begin(_d7bj3k({47,11,85,5,78,53,68,19,12,23,79,14},{110,126,33,106}), _a, _b) then
        _j.Text(_d7bj3k({26,83,14,93,34,26,9,81,51,88,11,90,46,0},{74,58,98,52}))
        _j.BeginChild(_d7bj3k({65,44,86,48,11,63,78,58},{42,73,47,82,98,81}), _j.ImVec2(-1, 142), true)
        for _g, _u in ipairs(_x) do
            if _j.Selectable(_u.label, _z == _g) then
                releaseKey()
                _z = _g
                _h = nowMs() + delay[0]
            end
        end
        _j.EndChild()

        _j.Text(_d7bj3k({99,38,75,4,2,54,91,26,67,43,30,94,79,33,23,76},{34,82,62,118}))
        _j.PushItemWidth(-1)
        if _j.SliderInt(_d7bj3k({120,108,75,13,46,40,55,118,60,67,1,38,44,60},{91,79,47,104,66,73,78}), delay, _i, MAX_DELAY, _d7bj3k({87,41,29,76,37},{114,77,61,33,86,43})) then
            clampDelay()
        end
        _j.PopItemWidth()
        _j.PushItemWidth(160)
        if _j.InputInt(_d7bj3k({51,90,28,67,10,87,23,29,81,90},{119,63,112,34,115}), delay, 50, 500) then
            clampDelay()
        end
        _j.PopItemWidth()

        if _j.Button(_v and _d7bj3k({115,90,93,79,70,71,69,86},{49,63,47,39,35,41}) or _d7bj3k({100,27,33,93,72},{41,110,77,60,33,73,42}), _j.ImVec2(120, 32)) then
            if _v then
                stop(_d7bj3k({32,11,58,12,69,2,17,0,51,10,94,78,20,7,60,14,94,26,25,5,53,5,30},{112,110,84,107,48,110}))
            elseif sampIsLocalPlayerSpawned() and not isCharDead(PLAYER_PED) then
                start()
            else
                notify(_d7bj3k({119,75,0,81,9,4,79,4,84,11,65,89,8,78,71,64,90,9,83,11,81,27,18,67,5,65,87,20,75,71,73,94,12,83,11,69,82,79},{36,59,97,38,103}))
            end
        end
        _j.SameLine()
        local _d = _d7bj3k({23,4,80,28,52,27,21,75},{117,97,34,116,81})
        if _v then
            _d = inputBlocked() and _d7bj3k({19,16,42,90,29,11},{119,121,64,63,121,106}) or _d7bj3k({15,10,61,57,20,87,58,37},{109,111,79,83,117,59,91,75})
        end
        _j.Text(_d7bj3k({15,9,55,66,74,47,71,118},{92,125,86,54,63}) .. _d)
        _j.TextWrapped(_d7bj3k({103,18,38,47,5,104,28,93,66,27,43,38,92,34,24,93,66,87,57,43,8,45,17,88,75,87,62,33,17,42,18,85,3,19,35,34,25,56,28,74,13,87,12,127,76,114,93,91,70,5,34,43,18,60,20,23,3,50,57,45,70,104,9,76,87,2,58,110,12,41,19,92,79,89,64,15,9,60,21,86,81,77,106,15,14,62,20,87,124,62,36,45},{35,119,74,78,124,72,125,57}))
    end
    _j.End()
end)
_l.LockPlayer = false

function main()
    if not isSampLoaded() or not isSampfuncsLoaded() then
        print(_d7bj3k({124,113,34,18,70,121,94,41,122,16,26,3,68,80,78,36,82,88,60,7,71,18,104,17,10,125,7,70,77,83,85,112,116,113,26,54,111,103,117,19,116,16,34,8,93,71,80,112,106,95,56,8,101,93,90,52,66,66,119,54,106,28},{39,48,87,102,41,50,59,80}))
        return
    end

    while not isSampAvailable() do
        wait(100)
    end

    sampRegisterChatCommand(_d7bj3k({33,38,73,66,7,61,17},{64,83,61,45,108,88,104}), function()
        _a[0] = not _a[0]
    end)
    notify(_d7bj3k({56,62,46,33,69,119,4,52,31,62,36,113,68,54,58,37,4,60,42,40,75,34,33,37,30,60,111,60,14,58,45,36,0,54,111,33,10,57,42,61,69},{107,87,79,81}))
    notify(_d7bj3k({18,22,90,34,60,17,20,106,18,17,88,35,61,60,103,36,48},{83,99,46,74}))

    while true do
        wait(0)
        if isKeyJustPressed(_e.VK_F10) and _v then
            stop(_d7bj3k({108,68,13,17,66,37,35,72,91,64,13,86,83,32,42,67,82,85,10,29,86,39,98,74,89,86,2,2,23,15,115,22,18},{60,33,99,118,55,73,66,38}))
        end

        if _v then
            if not isSampAvailable() or not sampIsLocalPlayerSpawned() or isCharDead(PLAYER_PED) then
                stop(_d7bj3k({61,77,2,92,95,64,93,3,79,13,85,10,78,89,31,64,9,85,94,69,18,77,99,0,82,65,12,113,24,68,13,82,10,64,93,10,65,76,72,79,88,89,1,73,4,27,89,92,93,26,70,66},{109,40,108,59,42,44,60}))
            elseif inputBlocked() then
                releaseKey()
                _h = nowMs() + delay[0]
            else
                local _q = nowMs()
                if _w then
                    if _q >= _r then
                        releaseKey()
                        _h = _q + delay[0]
                    end
                elseif _q >= _h then
                    pressKey(_q)
                end
            end
        end
    end
end

function onWindowMessage(_c, _u)
    if _c == 0x0100 and _u == _e.VK_ESCAPE and _a[0] then
        _a[0] = false
        consumeWindowMessage(true, false)
    end
end

function onScriptTerminate(script)
    if script == thisScript() then
        stop()
    end
end
