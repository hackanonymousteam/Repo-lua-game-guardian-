
local json = nil
if not pcall(function()
    json = load(gg.makeRequest("https://raw.githubusercontent.com/rxi/json.lua/master/json.lua").content)()
end) then
    if pcall(function() json = require("json") end) then
    else
        json = {
            encode = function(t)
                local result = {}
                for k, v in pairs(t) do
                    if type(k) == "string" then
                        table.insert(result, '"' .. k .. '":' .. json.encode(v))
                    end
                end
                return "{" .. table.concat(result, ",") .. "}"
            end,
            
            decode = function(s)
                if not s or s == "" then return {} end
                local result = {}
                s = s:gsub("^{", ""):gsub("}$", "")
                for pair in s:gmatch('"([^"]+)":([^,}]+)') do
                    local k, v = pair:match('([^:]+):(.+)')
                    if k then
                        result[k] = tonumber(v) or v:gsub('"', '')
                    end
                end
                return result
            end
        }
    end
end

local persistence = {
    filename =  gg.EXT_CACHE_DIR .. "/menu.json",

    save = function(self, data)
        local success, encoded = pcall(json.encode, data)
        if success and encoded then
            local file = io.open(self.filename, "w")
            if file then
                file:write(encoded)
                file:close()
                return true
            end
        end
        return false
    end,
    
    load = function(self)
        local file = io.open(self.filename, "r")
        if file then
            local content = file:read("*a")
            file:close()
            if content and content ~= "" then
                local success, data = pcall(json.decode, content)
                if success then
                    return data
                end
            end
        end
        return nil
    end,
    
    clear = function(self)
        os.remove(self.filename)
        return true
    end
}

local AdaptiveBrain = {
    usage_data = {},
    function_weights = {},
    menu_history = {},
    current_session = {}
}

function AdaptiveBrain:new()
    local obj = {
        usage_data = {
            wallhack = 0,
            camera_hack = 0,
            fly_climb = 0,
            aimbot = 0,
            speed = 0,
            god = 0,
            money = 0,
            vision = 0,
            total_interactions = 0
        },
        function_weights = {},
        menu_history = {},
        current_session = {},
        session_start = os.time()
    }
    setmetatable(obj, {__index = self})
    obj:load_persistent_data()
    obj:initialize_weights()
    return obj
end

function AdaptiveBrain:load_persistent_data()
    local saved = persistence:load()
    if saved then
        if saved.usage_data then
            for k, v in pairs(saved.usage_data) do
                if type(v) == "number" then
                    self.usage_data[k] = v
                end
            end
        end
        
        if saved.function_weights and type(saved.function_weights) == "table" then
            for func_name, weight_data in pairs(saved.function_weights) do
                if type(weight_data) == "table" then
                    self.function_weights[func_name] = weight_data
                end
            end
        end
        
        if saved.menu_history and type(saved.menu_history) == "table" then
            self.menu_history = saved.menu_history
        end
        
        gg.toast("📊 Loaded: " .. (self.usage_data.total_interactions or 0) .. " interactions")
    else
        gg.toast("✨ New system started")
    end
end

function AdaptiveBrain:save_persistent_data()
    local data = {
        usage_data = self.usage_data,
        function_weights = self.function_weights,
        menu_history = self.menu_history,
        last_update = os.time()
    }
    
    persistence:save(data)
end

function AdaptiveBrain:initialize_weights()
    local functions_list = {
        "wallhack", "camera_hack", "fly_climb", 
        "aimbot", "speed", "god", "money", "vision"
    }
    
    for _, func in ipairs(functions_list) do
        if not self.function_weights[func] or type(self.function_weights[func]) ~= "table" then
            self.function_weights[func] = {
                usage_count = self.usage_data[func] or 0,
                last_used = 0,
                priority = 1.0
            }
        end
    end
end

function AdaptiveBrain:record_usage(function_name)
    if self.usage_data[function_name] then
        self.usage_data[function_name] = self.usage_data[function_name] + 1
    end
    self.usage_data.total_interactions = self.usage_data.total_interactions + 1
    
    if not self.function_weights[function_name] then
        self.function_weights[function_name] = {
            usage_count = 0,
            last_used = 0,
            priority = 1.0
        }
    end
    
    local weight = self.function_weights[function_name]
    weight.usage_count = weight.usage_count + 1
    weight.last_used = os.time()
    
    table.insert(self.menu_history, {
        function_name = function_name,
        timestamp = os.time()
    })
    
    table.insert(self.current_session, function_name)
    
    if self.usage_data.total_interactions % 3 == 0 then
        self:save_persistent_data()
    end
end

function AdaptiveBrain:get_priority_order()
    local functions = {}
    
    for func_name, weight in pairs(self.function_weights) do
        if type(weight) == "table" then
            local recency = os.time() - weight.last_used
            local recency_factor = 1 / (1 + recency / 3600)
            weight.priority = (weight.usage_count / math.max(1, self.usage_data.total_interactions)) * 0.6 + recency_factor * 0.4
            
            table.insert(functions, {
                name = func_name,
                priority = weight.priority,
                usage = weight.usage_count
            })
        end
    end
    
    table.sort(functions, function(a, b)
        if a.priority == b.priority then
            return a.usage > b.usage
        end
        return a.priority > b.priority
    end)
    
    local result = {}
    for _, func in ipairs(functions) do
        table.insert(result, func.name)
    end
    
    local all_funcs = {"wallhack", "camera_hack", "fly_climb", "aimbot", "speed", "god", "money", "vision"}
    for _, func in ipairs(all_funcs) do
        local found = false
        for _, r in ipairs(result) do
            if r == func then found = true end
        end
        if not found then
            table.insert(result, func)
        end
    end
    
    return result
end

function AdaptiveBrain:get_menu_display()
    local order = self:get_priority_order()
    local menu_items = {}
    local menu_funcs = {}
    
    local display_map = {
        wallhack = "👁️ WALLHACK",
        camera_hack = "📷 CAMERA",
        fly_climb = "🚀 FLY/CLIMB",
        aimbot = "🎯 AIMBOT",
        speed = "⚡ SPEED",
        god = "🛡️ GOD MODE",
        money = "💰 MONEY",
        vision = "🔍 VISION"
    }
    
    for i, func in ipairs(order) do
        local display = display_map[func] or func
        local weight = self.function_weights[func]
        
        if weight and weight.usage_count > 0 then
            if weight.usage_count > 5 then
                display = display .. " ⭐"
            end
        end
        
        table.insert(menu_items, display)
        table.insert(menu_funcs, func)
    end
    
    table.insert(menu_items, "◖ EXIT ◗")
    
    return menu_items, menu_funcs
end

local brain = AdaptiveBrain:new()

local states = {
    wallhack = false,
    camera_hack = false,
    fly_climb = false,
    aimbot = false,
    speed = false,
    god = false,
    money = false,
    vision = false
}

function execute_wallhack()
    brain:record_usage("wallhack")
    states.wallhack = not states.wallhack
    if states.wallhack then
        gg.toast("👁️ Wallhack ON")
    else
        gg.toast("👁️ Wallhack OFF")
    end
end

function execute_camera_hack()
    brain:record_usage("camera_hack")
    states.camera_hack = not states.camera_hack
    if states.camera_hack then
        gg.toast("📷 Camera Hack ON")
    else
        gg.toast("📷 Camera Hack OFF")
    end
end

function execute_fly_climb()
    brain:record_usage("fly_climb")
    states.fly_climb = not states.fly_climb
    if states.fly_climb then
        gg.toast("🚀 Fly/Climb ON")
    else
        gg.toast("🚀 Fly/Climb OFF")
    end
end

function execute_aimbot()
    brain:record_usage("aimbot")
    states.aimbot = not states.aimbot
    if states.aimbot then
        gg.toast("🎯 Aimbot ON")
    else
        gg.toast("🎯 Aimbot OFF")
    end
end

function execute_speed()
    brain:record_usage("speed")
    states.speed = not states.speed
    if states.speed then
        gg.toast("⚡ Speed Hack ON")
    else
        gg.toast("⚡ Speed Hack OFF")
    end
end

function execute_god()
    brain:record_usage("god")
    states.god = not states.god
    if states.god then
        gg.toast("🛡️ God Mode ON")
    else
        gg.toast("🛡️ God Mode OFF")
    end
end

function execute_money()
    brain:record_usage("money")
    states.money = not states.money
    if states.money then
        gg.toast("💰 Money Hack ON")
    else
        gg.toast("💰 Money Hack OFF")
    end
end

function execute_vision()
    brain:record_usage("vision")
    states.vision = not states.vision
    if states.vision then
        gg.toast("🔍 Enhanced Vision ON")
    else
        gg.toast("🔍 Enhanced Vision OFF")
    end
end

function show_smart_menu()
    local menu_items, menu_funcs = brain:get_menu_display()
    
    local title = "🧠 Smart Menu (" .. brain.usage_data.total_interactions .. ")"
    
    local choice = gg.choice(menu_items, nil, title)
    
    if not choice then return end
    
    if choice <= #menu_funcs then
        local func = menu_funcs[choice]
        
        if func == "wallhack" then
            execute_wallhack()
        elseif func == "camera_hack" then
            execute_camera_hack()
        elseif func == "fly_climb" then
            execute_fly_climb()
        elseif func == "aimbot" then
            execute_aimbot()
        elseif func == "speed" then
            execute_speed()
        elseif func == "god" then
            execute_god()
        elseif func == "money" then
            execute_money()
        elseif func == "vision" then
            execute_vision()
        end
    else
        brain:save_persistent_data()
        os.exit()
    end
end

gg.setVisible(true)
gg.toast("🧠 Smart Menu Loaded")

if brain.usage_data.total_interactions == 0 then
    gg.toast("✨ New system - it learns from your use")
end

while true do
    if gg.isVisible(true) then
        gg.setVisible(false)
        show_smart_menu()
    end
    gg.sleep(100)
end