--[[
Улучшенный скрипт приватного чата с поддержкой множества языков
]]

-- Таблица транслитерации русского текста в латиницу (улучшенная)
local translit = {
    ["а"] = "a", ["б"] = "b", ["в"] = "v", ["г"] = "g", ["д"] = "d", ["е"] = "e", ["ё"] = "yo",
    ["ж"] = "zh", ["з"] = "z", ["и"] = "i", ["й"] = "j", ["к"] = "k", ["л"] = "l", ["м"] = "m",
    ["н"] = "n", ["о"] = "o", ["п"] = "p", ["р"] = "r", ["с"] = "s", ["т"] = "t", ["у"] = "u",
    ["ф"] = "f", ["х"] = "h", ["ц"] = "c", ["ч"] = "ch", ["ш"] = "sh", ["щ"] = "shh", ["ъ"] = "'",
    ["ы"] = "y", ["ь"] = "'", ["э"] = "eh", ["ю"] = "yu", ["я"] = "ya", [" "] = " ", [","] = ",",
    ["."] = ".", ["!"] = "!", ["?"] = "?", ["-"] = "-", [":"] = ":", [";"] = ";"
}

-- Обратная транслитерация с латиницы на русский (улучшенная)
local detranslit = {
    ["a"] = "а", ["b"] = "б", ["v"] = "в", ["g"] = "г", ["d"] = "д", ["e"] = "е", ["yo"] = "ё",
    ["zh"] = "ж", ["z"] = "з", ["i"] = "и", ["j"] = "й", ["k"] = "к", ["l"] = "л", ["m"] = "м",
    ["n"] = "н", ["o"] = "о", ["p"] = "п", ["r"] = "р", ["s"] = "с", ["t"] = "т", ["u"] = "у",
    ["f"] = "ф", ["h"] = "х", ["c"] = "ц", ["ch"] = "ч", ["sh"] = "ш", ["shh"] = "щ", ["''"] = "ъ",
    ["y"] = "ы", ["'"] = "ь", ["eh"] = "э", ["yu"] = "ю", ["ya"] = "я", [" "] = " ", [","] = ",",
    ["."] = ".", ["!"] = "!", ["?"] = "?", ["-"] = "-", [":"] = ":", [";"] = ";"
}

-- Таблицы соответствия для языков
local language_tables = {
    english = { 
        to_hieroglyph = { 
            a = "a", b = "b", c = "c", d = "d", e = "e", f = "f", g = "g", h = "h", 
            i = "i", j = "j", k = "k", l = "l", m = "m", n = "n", o = "o", p = "p", 
            q = "q", r = "r", s = "s", t = "t", u = "u", v = "v", w = "w", x = "x", 
            y = "y", z = "z" 
        }, 
        from_hieroglyph = {} 
    },
    
    chinese = { 
        to_hieroglyph = { 
            a = "的", b = "一", c = "是", d = "不", e = "了", f = "人", g = "我", h = "在", 
            i = "有", j = "他", k = "这", l = "为", m = "之", n = "大", o = "来", p = "以", 
            q = "个", r = "中", s = "上", t = "们", u = "到", v = "说", w = "国", x = "和", 
            y = "地", z = "也" 
        }, 
        from_hieroglyph = {} 
    },
    
    japanese = { 
        to_hieroglyph = { 
            a = "あ", b = "い", c = "う", d = "え", e = "お", f = "か", g = "き", h = "く", 
            i = "け", j = "こ", k = "さ", l = "し", m = "す", n = "せ", o = "そ", p = "た", 
            q = "ち", r = "つ", s = "て", t = "と", u = "な", v = "に", w = "ぬ", x = "ね", 
            y = "の", z = "は" 
        }, 
        from_hieroglyph = {} 
    },
    
    korean = { 
        to_hieroglyph = { 
            a = "가", b = "나", c = "다", d = "라", e = "마", f = "바", g = "사", h = "아", 
            i = "자", j = "차", k = "카", l = "타", m = "파", n = "하", o = "거", p = "너", 
            q = "더", r = "러", s = "머", t = "버", u = "서", v = "어", w = "저", x = "처", 
            y = "커", z = "터" 
        }, 
        from_hieroglyph = {} 
    },
    
    armenian = { 
        to_hieroglyph = {
            a = "ա", b = "բ", c = "ց", d = "դ", e = "ե", f = "ֆ", g = "գ", h = "հ", 
            i = "ի", j = "ջ", k = "կ", l = "լ", m = "մ", n = "ն", o = "ո", p = "պ", 
            q = "ք", r = "ր", s = "ս", t = "տ", u = "ու", v = "վ", w = "վ", x = "խ", 
            y = "յ", z = "զ"
        },
        from_hieroglyph = {}
    },
    
    arabic = { 
        to_hieroglyph = { 
            a = "ا", b = "ب", c = "ت", d = "ث", e = "ج", f = "ح", g = "خ", h = "د", 
            i = "ذ", j = "ر", k = "ز", l = "س", m = "ش", n = "ص", o = "ض", p = "ط", 
            q = "ظ", r = "ع", s = "غ", t = "ف", u = "ق", v = "ك", w = "ل", x = "م", 
            y = "ن", z = "ه" 
        }, 
        from_hieroglyph = {} 
    },
    
    hindi = { 
        to_hieroglyph = { 
            a = "अ", b = "आ", c = "इ", d = "ई", e = "उ", f = "ऊ", g = "ऋ", h = "ए", 
            i = "ऐ", j = "ओ", k = "औ", l = "क", m = "ख", n = "ग", o = "घ", p = "च", 
            q = "छ", r = "ज", s = "झ", t = "ञ", u = "ट", v = "ठ", w = "ड", x = "ढ", 
            y = "ण", z = "त" 
        }, 
        from_hieroglyph = {} 
    },
    
    french = { 
        to_hieroglyph = { 
            a = "à", b = "b", c = "ç", d = "d", e = "é", f = "f", g = "g", h = "h", 
            i = "î", j = "j", k = "k", l = "l", m = "m", n = "n", o = "ô", p = "p", 
            q = "q", r = "r", s = "s", t = "t", u = "ù", v = "v", w = "w", x = "x", 
            y = "y", z = "z" 
        }, 
        from_hieroglyph = {} 
    },
    
    german = { 
        to_hieroglyph = { 
            a = "ä", b = "b", c = "c", d = "d", e = "e", f = "f", g = "g", h = "h", 
            i = "i", j = "j", k = "k", l = "l", m = "m", n = "n", o = "ö", p = "p", 
            q = "q", r = "r", s = "ß", t = "t", u = "ü", v = "v", w = "w", x = "x", 
            y = "y", z = "z" 
        }, 
        from_hieroglyph = {} 
    },
    
    spanish = { 
        to_hieroglyph = { 
            a = "á", b = "b", c = "c", d = "d", e = "é", f = "f", g = "g", h = "h", 
            i = "í", j = "j", k = "k", l = "l", m = "m", n = "ñ", o = "ó", p = "p", 
            q = "q", r = "r", s = "s", t = "t", u = "ú", v = "v", w = "w", x = "x", 
            y = "y", z = "z" 
        }, 
        from_hieroglyph = {} 
    }
}

-- Заполнение обратных таблиц для дешифрования
for lang, table in pairs(language_tables) do
    for k, v in pairs(table.to_hieroglyph) do
        table.from_hieroglyph[v] = k
    end
end

-- Флаги и текущий язык
local enable_russian = true
local enable_universal_translation = false
local current_language = "armenian" -- По умолчанию армянский
local active_language_button = nil
local chat_system = nil

-- Функция поиска DefaultChatSystemChatEvents
local function findChatSystem()
    for _, obj in pairs(game:GetDescendants()) do
        if obj.Name == "DefaultChatSystemChatEvents" and obj:IsA("Instance") then
            return obj
        end
    end
    return nil
end

-- Инициализация системы чата
local function initializeChatSystem()
    chat_system = findChatSystem()
    if not chat_system then
        warn("Falling back to TextChatService: DefaultChatSystemChatEvents not found")
    else
        print("DefaultChatSystemChatEvents found at: " .. chat_system:GetFullName())
    end
end

-- Улучшенная функция транслитерации русского текста в латиницу
local function transliterate(str)
    local result = ""
    local i = 1
    while i <= #str do
        local char = str:sub(i, i):lower()
        if i < #str then
            local next_char = str:sub(i+1, i+1):lower()
            local two_chars = char .. next_char
            
            -- Проверяем двухсимвольные комбинации в первую очередь
            if translit[two_chars] then
                result = result .. translit[two_chars]
                i = i + 2
            elseif translit[char] then
                result = result .. translit[char]
                i = i + 1
            else
                result = result .. char
                i = i + 1
            end
        elseif translit[char] then
            result = result .. translit[char]
            i = i + 1
        else
            result = result .. char
            i = i + 1
        end
    end
    return result
end

-- Улучшенная функция обратной транслитерации с латиницы на русский
local function detransliterate(str)
    local result = ""
    local i = 1
    while i <= #str do
        local found = false
        
        -- Проверяем трехсимвольные комбинации (например "shh")
        if i <= #str - 2 then
            local three_chars = str:sub(i, i+2):lower()
            if detranslit[three_chars] then
                result = result .. detranslit[three_chars]
                i = i + 3
                found = true
            end
        end
        
        -- Проверяем двухсимвольные комбинации (например "ch", "sh")
        if not found and i <= #str - 1 then
            local two_chars = str:sub(i, i+1):lower()
            if detranslit[two_chars] then
                result = result .. detranslit[two_chars]
                i = i + 2
                found = true
            end
        end
        
        -- Проверяем одиночные символы
        if not found then
            local char = str:sub(i, i):lower()
            if detranslit[char] then
                result = result .. detranslit[char]
            else
                result = result .. char
            end
            i = i + 1
        end
    end
    return result
end

-- Функция шифрования текста
local function convert(str)
    if enable_russian then
        str = transliterate(str)
    end
    local table = language_tables[current_language].to_hieroglyph
    local result = ""
    for char in string.gmatch(str:lower(), "[%z\1-\127\194-\244][\128-\191]*") do
        if table[char] then
            result = result .. table[char]
        else
            result = result .. char
        end
    end
    return result
end

-- Функция дешифрования текста (автоматически для всех языков)
local function unconvert(str)
    local latin_result = ""
    local i = 1
    local max_lookahead = 3 -- Максимальная длина иероглифа в символах
    
    while i <= #str do
        local found = false
        local remaining = #str - i + 1
        local max_check = math.min(max_lookahead, remaining)
        
        -- Проверяем каждый язык
        for lang, lang_table in pairs(language_tables) do
            local table = lang_table.from_hieroglyph
            -- Проверяем от самых длинных комбинаций к самым коротким
            for check_len = max_check, 1, -1 do
                local substr = str:sub(i, i + check_len - 1)
                if table[substr] then
                    latin_result = latin_result .. table[substr]
                    i = i + check_len
                    found = true
                    break
                end
            end
            if found then break end
        end
        
        if not found then
            latin_result = latin_result .. str:sub(i, i)
            i = i + 1
        end
    end
    
    -- Если включен русский режим, преобразуем латиницу обратно в русский
    if enable_russian then
        return detransliterate(latin_result)
    end
    
    return latin_result
end

-- Функция перевода всех языков
local function translate_all_languages(str)
    local translations = {}
    for lang in pairs(language_tables) do
        local decrypted = unconvert(str)
        if decrypted ~= str and #decrypted > 0 then
            table.insert(translations, {lang = lang, text = decrypted})
        end
    end
    
    if #translations > 0 then
        table.sort(translations, function(a, b)
            return #a.text > #b.text
        end)
        return translations[1].text
    end
    
    return str
end

-- Функция отправки сообщения в чат
local function chat(str)
    local success, err = pcall(function()
        if chat_system and chat_system:FindFirstChild("SayMessageRequest") then
            chat_system.SayMessageRequest:FireServer(str, "All")
        else
            local TextChatService = game:GetService("TextChatService")
            if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
                local channel = TextChatService.TextChannels:FindFirstChild("RBXGeneral") or TextChatService.TextChannels:GetChildren()[1]
                if channel then
                    channel:SendAsync(str)
                else
                    warn("No TextChatService channel available!")
                end
            else
                warn("No compatible chat system available!")
            end
        end
    end)
    if not success then
        warn("Chat error: " .. err)
    end
end

-- Создание интерфейса
local player = game:GetService("Players").LocalPlayer
local SG = Instance.new("ScreenGui", player.PlayerGui)
SG.Name = "HackerChatGui"

-- Основная рамка чата
local frame = Instance.new("Frame", SG)
frame.Size = UDim2.new(0.2, 0, 0.2, 0)
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.Position = UDim2.new(0.5, 0, 0.8, 0)
frame.Active = true
frame.Draggable = true
frame.BackgroundColor3 = Color3.new(0.14902, 0.8, 1)

-- Текстовое поле для ввода
local textbox = Instance.new("TextBox", frame)
textbox.AnchorPoint = Vector2.new(0.5, 0.5)
textbox.Size = UDim2.new(0.95, 0, 0.65, 0)
textbox.Position = UDim2.new(0.5, 0, 0.6, 0)
textbox.TextScaled = true
textbox.BackgroundColor3 = Color3.new(1, 1, 1)
textbox.Text = "Text"
textbox.TextColor3 = Color3.new(0, 0, 0)

-- Заголовок
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(0.3, 0, 0.3, 0)
title.TextScaled = true
title.Text = "hacker chat"
title.BackgroundTransparency = 1
title.TextColor3 = Color3.new(0, 0, 0)

-- Кнопка закрытия
local closebutton = Instance.new("TextButton", frame)
closebutton.Size = UDim2.new(0.15, 0, 0.25, 0)
closebutton.AnchorPoint = Vector2.new(1, 0)
closebutton.TextScaled = true
closebutton.BackgroundColor3 = Color3.new(1, 0, 0.0156863)
closebutton.Text = "X"
closebutton.Position = UDim2.new(1, 0, 0, 0)
closebutton.TextColor3 = Color3.new(1, 1, 1)

-- Кнопка настроек
local settingsbutton = Instance.new("TextButton", frame)
settingsbutton.Size = UDim2.new(0.15, 0, 0.25, 0)
settingsbutton.AnchorPoint = Vector2.new(1, 0)
settingsbutton.Position = UDim2.new(0.85, 0, 0, 0)
settingsbutton.TextScaled = true
settingsbutton.BackgroundColor3 = Color3.new(0, 1, 0)
settingsbutton.Text = "⚙"
settingsbutton.TextColor3 = Color3.new(1, 1, 1)

-- Рамка настроек с прокруткой
local settingsFrame = Instance.new("ScrollingFrame", SG)
settingsFrame.Size = UDim2.new(0.15, 0, 0.15, 0)
settingsFrame.Position = UDim2.new(0.5, 0, 0.65, 0)
settingsFrame.AnchorPoint = Vector2.new(0.5, 0.5)
settingsFrame.BackgroundColor3 = Color3.new(0.14902, 0.8, 1)
settingsFrame.Visible = false
settingsFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
settingsFrame.ScrollBarThickness = 5
settingsFrame.ScrollingEnabled = true
settingsFrame.BorderSizePixel = 0

-- Чекбокс для шифрования русского текста
local russianCheckbox = Instance.new("TextButton", settingsFrame)
russianCheckbox.Size = UDim2.new(0.9, 0, 0, 30)
russianCheckbox.Position = UDim2.new(0.5, 0, 0, 5)
russianCheckbox.AnchorPoint = Vector2.new(0.5, 0)
russianCheckbox.Text = "Русский: " .. (enable_russian and "✓" or "✗")
russianCheckbox.TextScaled = true
russianCheckbox.BackgroundColor3 = Color3.new(1, 1, 1)
russianCheckbox.TextColor3 = Color3.new(0, 0, 0)

-- Чекбокс для универсального перевода (все сообщения)
local universalCheckbox = Instance.new("TextButton", settingsFrame)
universalCheckbox.Size = UDim2.new(0.9, 0, 0, 30)
universalCheckbox.Position = UDim2.new(0.5, 0, 0, 40)
universalCheckbox.AnchorPoint = Vector2.new(0.5, 0)
universalCheckbox.Text = "Универсал: " .. (enable_universal_translation and "✓" or "✗")
universalCheckbox.TextScaled = true
universalCheckbox.BackgroundColor3 = Color3.new(1, 1, 1)
universalCheckbox.TextColor3 = Color3.new(0, 0, 0)

-- Создание кнопок для выбора языка
local y_offset = 75
local language_count = 0
local language_buttons = {}
for lang in pairs(language_tables) do
    local button = Instance.new("TextButton", settingsFrame)
    button.Size = UDim2.new(0.9, 0, 0, 30)
    button.Position = UDim2.new(0.5, 0, 0, y_offset)
    button.AnchorPoint = Vector2.new(0.5, 0)
    button.Text = lang
    button.TextScaled = true
    button.BackgroundColor3 = (lang == current_language) and Color3.new(0, 1, 0) or Color3.new(1, 1, 1)
    button.TextColor3 = Color3.new(0, 0, 0)
    button.MouseButton1Up:Connect(function()
        if active_language_button then
            active_language_button.BackgroundColor3 = Color3.new(1, 1, 1)
        end
        current_language = lang
        button.BackgroundColor3 = Color3.new(0, 1, 0)
        active_language_button = button
    end)
    language_buttons[lang] = button
    y_offset = y_offset + 35
    language_count = language_count + 1
end

-- Установка начальной активной кнопки
if language_buttons[current_language] then
    active_language_button = language_buttons[current_language]
    active_language_button.BackgroundColor3 = Color3.new(0, 1, 0)
end

-- Обновление CanvasSize
settingsFrame.CanvasSize = UDim2.new(0, 0, 0, 70 + (language_count * 35))

-- Кнопка закрытия настроек (прикреплена к рамке, не скроллится)
local closeSettingsButton = Instance.new("TextButton", settingsFrame)
closeSettingsButton.Size = UDim2.new(0.2, 0, 0, 20)
closeSettingsButton.Position = UDim2.new(1, 0, 0, 0)
closeSettingsButton.AnchorPoint = Vector2.new(1, 0)
closeSettingsButton.Text = "X"
closeSettingsButton.TextScaled = true
closeSettingsButton.BackgroundColor3 = Color3.new(1, 0, 0)
closeSettingsButton.TextColor3 = Color3.new(1, 1, 1)
closeSettingsButton.ZIndex = 2 -- Чтобы была поверх списка

-- Ограничение пропорций интерфейса
local ui = Instance.new("UIAspectRatioConstraint", frame)
ui.AspectRatio = 4

-- Инициализация чата при запуске
initializeChatSystem()

-- Обработчики событий
closebutton.MouseButton1Up:Connect(function()
    SG:Destroy()
end)

settingsbutton.MouseButton1Up:Connect(function()
    settingsFrame.Visible = not settingsFrame.Visible
end)

russianCheckbox.MouseButton1Up:Connect(function()
    enable_russian = not enable_russian
    russianCheckbox.Text = "Русский: " .. (enable_russian and "✓" or "✗")
end)

universalCheckbox.MouseButton1Up:Connect(function()
    enable_universal_translation = not enable_universal_translation
    universalCheckbox.Text = "Универсал: " .. (enable_universal_translation and "✓" or "✗")
end)

closeSettingsButton.MouseButton1Up:Connect(function()
    settingsFrame.Visible = false
end)

textbox.FocusLost:Connect(function()
    local encrypted = "三" .. convert(textbox.Text)
    chat(encrypted)
end)

-- Улучшенная обработка сообщений через PlayerGui.Chat
local chatFrame = player.PlayerGui:WaitForChild("Chat", 5)
if chatFrame then
    print("Chat GUI found, enabling standard chat decryption")
    local scroller = chatFrame:WaitForChild("Frame").ChatChannelParentFrame.Frame_MessageLogDisplay.Scroller
    scroller.ChildAdded:Connect(function(msg)
        wait(0.5)
        local message = msg.TextLabel.Text
        if message:match("三") then
            msg.TextLabel.TextColor3 = Color3.new(1, 0.85098, 0)
            local decrypted = unconvert(message:gsub("三", "", 1))
            msg.TextLabel.Text = decrypted
            print("Decrypted message (encrypted): " .. decrypted)
        elseif enable_universal_translation then
            local decrypted = translate_all_languages(message)
            if decrypted ~= message then
                msg.TextLabel.TextColor3 = Color3.new(0, 1, 0)
                msg.TextLabel.Text = decrypted
                print("Decrypted message (universal): " .. decrypted)
            end
        end
    end)
else
    warn("Chat GUI not found, switching to TextChatService or BubbleChat!")
end

-- Улучшенная поддержка TextChatService (все каналы)
local TextChatService = game:GetService("TextChatService")
if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
    print("TextChatService detected, scanning channels...")
    
    local function processChannelMessage(channel, message)
        local text = message.Text
        if text:match("三") then
            local decrypted = unconvert(text:gsub("三", "", 1))
            
            local label = Instance.new("TextLabel", SG)
            label.Size = UDim2.new(0.4, 0, 0.05, 0)
            label.Position = UDim2.new(0.5, 0, 0.05, 0)
            label.AnchorPoint = Vector2.new(0.5, 0)
            label.BackgroundTransparency = 0.5
            label.BackgroundColor3 = Color3.new(0, 0, 0)
            label.TextColor3 = Color3.new(1, 0.85098, 0)
            label.Text = decrypted
            label.TextScaled = true
            label.ZIndex = 10
            game:GetService("Debris"):AddItem(label, 10)
            
            print("Decrypted message (encrypted): " .. decrypted)
        elseif enable_universal_translation then
            local decrypted = translate_all_languages(text)
            if decrypted ~= text then
                local label = Instance.new("TextLabel", SG)
                label.Size = UDim2.new(0.4, 0, 0.05, 0)
                label.Position = UDim2.new(0.5, 0, 0.05, 0)
                label.AnchorPoint = Vector2.new(0.5, 0)
                label.BackgroundTransparency = 0.5
                label.BackgroundColor3 = Color3.new(0, 0, 0)
                label.TextColor3 = Color3.new(0, 1, 0)
                label.Text = decrypted
                label.TextScaled = true
                label.ZIndex = 10
                game:GetService("Debris"):AddItem(label, 10)
                
                print("Decrypted message (universal): " .. decrypted)
            end
        end
    end
    
    TextChatService.TextChannels.ChildAdded:Connect(function(channel)
        print("TextChatService channel found: " .. channel.Name)
        channel.MessageReceived:Connect(function(message)
            processChannelMessage(channel, message)
        end)
    end)
    
    for _, channel in pairs(TextChatService.TextChannels:GetChildren()) do
        print("TextChatService channel found: " .. channel.Name)
        channel.MessageReceived:Connect(function(message)
            processChannelMessage(channel, message)
        end)
    end
end

-- Улучшенная поддержка пузырькового чата
local Coregui = game:GetService("CoreGui")
if Coregui:FindFirstChild("BubbleChat") then
    print("BubbleChat detected, enabling decryption")
    
    local function processBubbleMessage(bubble, message)
        if message:match("三") then
            bubble.Parent.BackgroundColor3 = Color3.new(1, 0.85098, 0)
            local decrypted = unconvert(message:gsub("三", "", 1))
            bubble.Text = decrypted
            print("BubbleChat decrypted (encrypted): " .. decrypted)
        elseif enable_universal_translation then
            local decrypted = translate_all_languages(message)
            if decrypted ~= message then
                bubble.Parent.BackgroundColor3 = Color3.new(0, 1, 0)
                bubble.Text = decrypted
                print("BubbleChat decrypted (universal): " .. decrypted)
            end
        end
    end
    
    Coregui.BubbleChat.DescendantAdded:Connect(function(bubble)
        wait(0.5)
        if bubble:IsA("TextLabel") then
            local message = bubble.Text
            processBubbleMessage(bubble, message)
            
            bubble:GetPropertyChangedSignal("Text"):Connect(function()
                processBubbleMessage(bubble, bubble.Text)
            end)
        end
    end)
else
    print("BubbleChat not detected")
end
