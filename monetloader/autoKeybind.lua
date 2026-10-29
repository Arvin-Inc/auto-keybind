script_name('Auto Keybind')
script_description('Pengulangan keybind SA-MP melalui /autokey.')
script_version('1.0.0')

local imgui = require 'mimgui'
local vk = require 'vkeys'
local bit = require 'bit'

local keys = {
    {label = 'Y', code = vk.VK_Y},
    {label = 'ALT', code = vk.VK_MENU},
    {label = 'F', code = vk.VK_F},
    {label = 'H', code = vk.VK_H},
    {label = 'SPC (Spasi)', code = vk.VK_SPACE},
    {label = 'N', code = vk.VK_N},
}

local MIN_DELAY, MAX_DELAY, PRESS_MS = 50, 60000, 50
local window = imgui.new.bool(false)
local delay = imgui.new.int(500)
local selected = 1
local running = false
local heldKey = nil
local releaseAt = 0
local nextPressAt = 0

local function nowMs()
    return localClock() * 1000
end

local function clampDelay()
    delay[0] = math.max(MIN_DELAY, math.min(MAX_DELAY, delay[0]))
end

local function releaseKey()
    if heldKey then
        setVirtualKeyDown(heldKey, false)
        heldKey = nil
    end
end

local function notify(message)
    if isSampAvailable() then
        sampAddChatMessage('{8FBFFF}[AutoKey] {FFFFFF}' .. message, -1)
    end
end

local function stop(message)
    running = false
    releaseKey()
    if message then
        notify(message)
    end
end

local function start()
    clampDelay()
    releaseKey()
    running = true
    window[0] = false
    nextPressAt = nowMs() + delay[0]
    notify('Mulai: ' .. keys[selected].label .. ', delay ' .. delay[0] .. ' ms. F10 untuk berhenti.')
end

local function inputBlocked()
    return window[0]
        or not isGameWindowForeground()
        or isGamePaused()
        or sampIsChatInputActive()
        or sampIsDialogActive()
        or sampIsScoreboardOpen()
        or sampIsCursorActive()
end

imgui.OnInitialize(function()
    local style = imgui.GetStyle()
    style.WindowPadding = imgui.ImVec2(12, 10)
    style.FramePadding = imgui.ImVec2(8, 5)
    style.ItemSpacing = imgui.ImVec2(8, 7)
    style.WindowRounding = 5
    style.ChildRounding = 3
    style.FrameRounding = 3
    style.GrabRounding = 3
    style.WindowTitleAlign = imgui.ImVec2(0, 0.5)

    local colors, col = style.Colors, imgui.Col
    colors[col.Text] = imgui.ImVec4(0.94, 0.96, 1.00, 1)
    colors[col.TextDisabled] = imgui.ImVec4(0.65, 0.73, 0.82, 1)
    colors[col.WindowBg] = imgui.ImVec4(0.04, 0.08, 0.14, 1)
    colors[col.ChildBg] = imgui.ImVec4(0.05, 0.11, 0.19, 1)
    colors[col.TitleBg] = imgui.ImVec4(0.04, 0.12, 0.21, 1)
    colors[col.TitleBgActive] = imgui.ImVec4(0.07, 0.19, 0.32, 1)
    colors[col.Border] = imgui.ImVec4(0.20, 0.32, 0.46, 1)
    colors[col.FrameBg] = imgui.ImVec4(0.08, 0.18, 0.29, 1)
    colors[col.FrameBgHovered] = imgui.ImVec4(0.11, 0.25, 0.40, 1)
    colors[col.FrameBgActive] = imgui.ImVec4(0.13, 0.29, 0.46, 1)
    colors[col.Header] = imgui.ImVec4(0.12, 0.28, 0.45, 1)
    colors[col.HeaderHovered] = imgui.ImVec4(0.15, 0.33, 0.52, 1)
    colors[col.HeaderActive] = imgui.ImVec4(0.13, 0.29, 0.46, 1)
    colors[col.Button] = imgui.ImVec4(0.12, 0.36, 0.58, 1)
    colors[col.ButtonHovered] = imgui.ImVec4(0.15, 0.40, 0.63, 1)
    colors[col.ButtonActive] = imgui.ImVec4(0.10, 0.30, 0.50, 1)
    colors[col.SliderGrab] = imgui.ImVec4(0.53, 0.73, 0.96, 1)
    colors[col.SliderGrabActive] = imgui.ImVec4(0.69, 0.83, 1.00, 1)
    colors[col.NavHighlight] = imgui.ImVec4(0.69, 0.83, 1.00, 1)

    local io = imgui.GetIO()
    io.IniFilename = nil
    io.ConfigFlags = bit.bor(io.ConfigFlags, imgui.ConfigFlags.NavEnableKeyboard)
end)

local panel = imgui.OnFrame(function()
    return window[0] and isSampAvailable() and not isGamePaused()
end, function()
    local screenX, screenY = getScreenResolution()
    imgui.SetNextWindowPos(imgui.ImVec2(screenX / 2, screenY / 2),
        imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
    imgui.SetNextWindowSize(imgui.ImVec2(400, 390), imgui.Cond.FirstUseEver)

    local flags = imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse
    if imgui.Begin('Auto Keybind', window, flags) then
        imgui.Text('Pilih keybind:')
        imgui.BeginChild('keybinds', imgui.ImVec2(-1, 142), true)
        for index, key in ipairs(keys) do
            if imgui.Selectable(key.label, selected == index) then
                releaseKey()
                selected = index
                nextPressAt = nowMs() + delay[0]
            end
        end
        imgui.EndChild()

        imgui.Text('Atur delay (ms):')
        imgui.PushItemWidth(-1)
        if imgui.SliderInt('##delay-slider', delay, MIN_DELAY, MAX_DELAY, '%d ms') then
            clampDelay()
        end
        imgui.PopItemWidth()
        imgui.PushItemWidth(160)
        if imgui.InputInt('Delay (ms)', delay, 50, 500) then
            clampDelay()
        end
        imgui.PopItemWidth()

        if imgui.Button(running and 'Berhenti' or 'Mulai', imgui.ImVec2(120, 32)) then
            if running then
                stop('Pengulangan dihentikan.')
            elseif sampIsLocalPlayerSpawned() and not isCharDead(PLAYER_PED) then
                start()
            else
                notify('Spawn terlebih dahulu sebelum memulai.')
            end
        end
        imgui.SameLine()
        imgui.Text(running and 'Status: dijeda (panel terbuka)' or 'Status: berhenti')
        imgui.TextWrapped('Delay adalah jeda setelah tombol dilepas. F10: berhenti. Esc: tutup panel.')
    end
    imgui.End()
end)
panel.LockPlayer = true

function main()
    if not isSampLoaded() or not isSampfuncsLoaded() then
        print('[AutoKey] Membutuhkan SA-MP dan SAMPFUNCS untuk MoonLoader PC.')
        return
    end

    while not isSampAvailable() do
        wait(100)
    end

    sampRegisterChatCommand('autokey', function()
        window[0] = not window[0]
        releaseKey()
        nextPressAt = nowMs() + delay[0]
    end)
    notify('Siap. Ketik /autokey untuk membuka panel.')
    notify('Author: Arvin_Inc')

    while true do
        wait(0)
        if isKeyJustPressed(vk.VK_F10) and running then
            stop('Pengulangan dihentikan lewat F10.')
        end

        if running then
            if not isSampAvailable() or not sampIsLocalPlayerSpawned() or isCharDead(PLAYER_PED) then
                stop('Pengulangan berhenti. Klik Mulai lagi setelah spawn.')
            elseif inputBlocked() then
                releaseKey()
                nextPressAt = nowMs() + delay[0]
            else
                local now = nowMs()
                if heldKey then
                    if now >= releaseAt then
                        releaseKey()
                        nextPressAt = now + delay[0]
                    end
                elseif now >= nextPressAt then
                    heldKey = keys[selected].code
                    setVirtualKeyDown(heldKey, true)
                    releaseAt = now + PRESS_MS
                end
            end
        end
    end
end

function onWindowMessage(message, key)
    if message == 0x0100 and key == vk.VK_ESCAPE and window[0] then
        window[0] = false
        consumeWindowMessage(true, false)
    end
end

function onScriptTerminate(script)
    if script == thisScript() then
        stop()
    end
end
