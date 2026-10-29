-- Run from the project root with Lua, or fengari-node-cli for the stub checks.
local scriptPath = arg[1] or 'autoKeybind.lua'
local passed = 0

local function equal(actual, expected, message)
    assert(actual == expected, (message or 'Unexpected value') .. ': expected '
        .. tostring(expected) .. ', got ' .. tostring(actual))
end

local function fixture()
    local f = {
        time = 0, inputs = {}, messages = {}, clicks = {}, visibleLabels = {},
        available = true, spawned = true, foreground = true, loaded = true,
        sampfuncs = true, paused = false, chat = false, dialog = false,
        scoreboard = false, cursor = false, dead = false, f10 = false,
        style = {Colors = {}}, io = {ConfigFlags = 0}, script = {},
    }
    local vk = {VK_Y = 0x59, VK_MENU = 0x12, VK_F = 0x46, VK_H = 0x48,
        VK_SPACE = 0x20, VK_N = 0x4E, VK_F10 = 0x79, VK_ESCAPE = 0x1B}
    local function enum(names)
        local values = {}
        for index, name in ipairs(names) do values[name] = index end
        return values
    end
    local function click(label)
        local value = f.clicks[label]
        f.clicks[label] = nil
        return value or false
    end
    local imgui = {
        new = {
            bool = function(value) f.window = {[0] = value}; return f.window end,
            int = function(value) f.delay = {[0] = value}; return f.delay end,
        },
        Col = enum({'Text', 'TextDisabled', 'WindowBg', 'ChildBg', 'TitleBg',
            'TitleBgActive', 'Border', 'FrameBg', 'FrameBgHovered', 'FrameBgActive',
            'Header', 'HeaderHovered', 'HeaderActive', 'Button', 'ButtonHovered',
            'ButtonActive', 'SliderGrab', 'SliderGrabActive', 'NavHighlight'}),
        ConfigFlags = {NavEnableKeyboard = 1}, Cond = {FirstUseEver = 4},
        WindowFlags = {NoResize = 2, NoCollapse = 32},
        GetStyle = function() return f.style end,
        GetIO = function() return f.io end,
        ImVec2 = function(x, y) return {x = x, y = y} end,
        ImVec4 = function(r, g, b, a) return {r, g, b, a} end,
        OnInitialize = function(callback) f.initialize = callback end,
        OnFrame = function(condition, draw)
            f.condition, f.draw, f.panel = condition, draw, {}
            return f.panel
        end,
        Begin = function(_, window)
            if click('X') then window[0] = false end
            return true
        end,
        Selectable = function(label) return click(label) end,
        Button = function(label) return click(label) end,
        SliderInt = function(_, value)
            if f.sliderValue then value[0], f.sliderValue = f.sliderValue, nil; return true end
            return false
        end,
        InputInt = function(_, value)
            if f.inputValue then value[0], f.inputValue = f.inputValue, nil; return true end
            return false
        end,
        Text = function(label) table.insert(f.visibleLabels, label) end,
        TextWrapped = function(label) table.insert(f.visibleLabels, label) end,
    }
    for _, name in ipairs({'SetNextWindowPos', 'SetNextWindowSize', 'BeginChild',
        'EndChild', 'PushItemWidth', 'PopItemWidth', 'SameLine', 'End'}) do
        imgui[name] = function() end
    end
    f.imgui = imgui
    local env = setmetatable({
        require = function(name)
            if name == 'mimgui' then return imgui end
            if name == 'vkeys' then return vk end
            if name == 'bit' then
                return {bor = function(a, b) equal(a, 0); equal(b, 1); return 1 end}
            end
            error('Unexpected module: ' .. name)
        end,
        script_name = function() end, script_description = function() end,
        script_version = function() end, print = function() end,
        localClock = function() return f.time / 1000 end,
        wait = function(ms) coroutine.yield(ms) end,
        isSampLoaded = function() return f.loaded end,
        isSampfuncsLoaded = function() return f.sampfuncs end,
        isSampAvailable = function() return f.available end,
        sampIsLocalPlayerSpawned = function() return f.spawned end,
        isGameWindowForeground = function() return f.foreground end,
        isGamePaused = function() return f.paused end,
        sampIsChatInputActive = function() return f.chat end,
        sampIsDialogActive = function() return f.dialog end,
        sampIsScoreboardOpen = function() return f.scoreboard end,
        sampIsCursorActive = function() return f.cursor end,
        isCharDead = function() return f.dead end, PLAYER_PED = 1,
        getScreenResolution = function() return 1280, 720 end,
        isKeyJustPressed = function(key)
            equal(key, vk.VK_F10)
            local pressed = f.f10; f.f10 = false; return pressed
        end,
        setVirtualKeyDown = function(key, down)
            table.insert(f.inputs, {key = key, down = down, time = f.time})
        end,
        sampRegisterChatCommand = function(command, callback)
            equal(command, 'autokey'); f.command = callback
        end,
        sampAddChatMessage = function(message) table.insert(f.messages, message) end,
        consumeWindowMessage = function(game, scripts)
            equal(game, true); equal(scripts, false); f.consumed = true
        end,
        thisScript = function() return f.script end,
    }, {__index = _G})
    local chunk
    if setfenv then chunk = setfenv(assert(loadfile(scriptPath)), env)
    else chunk = assert(loadfile(scriptPath, 't', env)) end
    chunk()
    f.initialize()
    f.thread = coroutine.create(env.main)
    function f:tick(time)
        self.time = time or self.time
        local ok, result = coroutine.resume(self.thread)
        assert(ok, result)
        return result
    end
    function f:render(clicks)
        self.clicks = clicks or {}
        assert(self.condition(), 'Panel must be visible')
        self.draw()
    end
    function f:start(label, delayMs)
        self.command()
        if label then self:render({[label] = true}) end
        if delayMs then self.inputValue = delayMs; self:render() end
        self:render({Mulai = true})
        equal(self.window[0], false)
    end
    f.env = env
    f:tick()
    return f
end

local function test(name, callback)
    callback()
    passed = passed + 1
    print('PASS ' .. name)
end

test('command toggles panel, theme and keyboard navigation initialized', function()
    local f = fixture()
    equal(f.window[0], false); equal(f.delay[0], 500)
    equal(f.io.ConfigFlags, 1); equal(f.panel.LockPlayer, true)
    equal(f.style.Colors[f.imgui.Col.WindowBg][3], 0.14)
    f.command(); equal(f.condition(), true)
    f.command(); equal(f.condition(), false); equal(#f.inputs, 0)
end)

test('all six choices produce the expected key, hold and release gap', function()
    local cases = {{'Y', 0x59}, {'ALT', 0x12}, {'F', 0x46}, {'H', 0x48},
        {'SPC (Spasi)', 0x20}, {'N', 0x4E}}
    for _, item in ipairs(cases) do
        local f = fixture(); f:start(item[1])
        f:tick(499); equal(#f.inputs, 0)
        f:tick(500); equal(f.inputs[1].key, item[2]); equal(f.inputs[1].down, true)
        f:tick(549); equal(#f.inputs, 1)
        f:tick(550); equal(f.inputs[2].down, false)
        f:tick(1049); equal(#f.inputs, 2)
        f:tick(1050); equal(f.inputs[3].down, true)
    end
end)

test('slider and number input apply delay and clamp both bounds', function()
    local f = fixture(); f.command()
    f.sliderValue = 1234; f:render(); equal(f.delay[0], 1234)
    f.inputValue = 750; f:render(); equal(f.delay[0], 750)
    for _, field in ipairs({'sliderValue', 'inputValue'}) do
        f[field] = -1; f:render(); equal(f.delay[0], 50)
        f[field] = 999999; f:render(); equal(f.delay[0], 60000)
    end
    f.inputValue = 750; f:render(); f:render({Mulai = true})
    f:tick(749); equal(#f.inputs, 0)
    f:tick(750); equal(f.inputs[1].down, true)
end)

test('F10 releases a held key and interrupts even a 60 second delay', function()
    local f = fixture(); f:start(); f:tick(500)
    f.f10 = true; f:tick(501); equal(f.inputs[2].down, false)
    f:tick(10000); equal(#f.inputs, 2)
    local long = fixture(); long:start(nil, 60000)
    long.f10 = true; long:tick(1); long:tick(70000); equal(#long.inputs, 0)
end)

test('chat, dialog, scoreboard, cursor, pause and focus loss release then wait', function()
    for _, state in ipairs({'chat', 'dialog', 'scoreboard', 'cursor', 'paused', 'foreground'}) do
        local f = fixture(); f:start(); f:tick(500)
        f[state] = state ~= 'foreground'
        f:tick(501); equal(f.inputs[2].down, false, state)
        f:tick(9000); equal(#f.inputs, 2, state)
        f[state] = state == 'foreground'
        f:tick(9001); equal(#f.inputs, 2, state)
        f:tick(9500); equal(f.inputs[3].down, true, state)
    end
end)

test('opening panel releases immediately; new selection resumes after closing', function()
    local f = fixture(); f:start(); f:tick(500)
    f.command(); equal(f.inputs[2].down, false)
    f:render({N = true}); f:tick(8000); equal(#f.inputs, 2)
    f.command(); f:tick(8499); equal(#f.inputs, 2)
    f:tick(8500); equal(f.inputs[3].key, 0x4E)
    f.command(); f:render({Berhenti = true})
    f.command(); f:tick(20000); equal(#f.inputs, 4)
end)

test('X and Escape close the panel; Escape is consumed', function()
    local f = fixture(); f.command(); f:render({X = true}); equal(f.window[0], false)
    f.command(); f.env.onWindowMessage(0x0100, 0x1B)
    equal(f.window[0], false); equal(f.consumed, true)
    f.consumed = false; f.env.onWindowMessage(0x0100, 0x1B); equal(f.consumed, false)
end)

test('death, disconnect and losing spawn stop until manually restarted', function()
    for _, state in ipairs({'dead', 'available', 'spawned'}) do
        local f = fixture(); f:start(); f:tick(500)
        f[state] = state == 'dead'; f:tick(501); equal(f.inputs[2].down, false, state)
        f[state] = state ~= 'dead'; f:tick(9000); equal(#f.inputs, 2, state)
    end
    local f = fixture(); f.spawned = false; f.command(); f:render({Mulai = true})
    equal(f.window[0], true); f:tick(9000); equal(#f.inputs, 0)
end)

test('script termination releases only its own held input', function()
    local f = fixture(); f:start(); f:tick(500)
    f.env.onScriptTerminate({}); equal(#f.inputs, 1)
    f.env.onScriptTerminate(f.script); equal(f.inputs[2].down, false)
    f:tick(9000); equal(#f.inputs, 2)
end)

test('low FPS advances one transition without a burst', function()
    local f = fixture(); f:start(); f:tick(5000); equal(#f.inputs, 1)
    f:tick(10000); equal(#f.inputs, 2); equal(f.inputs[2].down, false)
    f:tick(10001); equal(#f.inputs, 2)
    f:tick(10500); equal(#f.inputs, 3)
end)

test('panel hides when game paused or SA-MP unavailable', function()
    local f = fixture(); f.command()
    f.paused = true; equal(f.condition(), false)
    f.paused = false; f.available = false; equal(f.condition(), false)
end)

print(string.format('%d test groups passed (MoonLoader/mimgui stubs; not an in-game test).', passed))
