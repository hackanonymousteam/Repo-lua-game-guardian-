
local function complexLoop()
    local t = {}
    
    while true do
        for i = 1, 20000 do  
            t[i] = {}
            for j = 1, 200 do  
                t[i][j] = string.rep("B", 2048)  
            end
        end
        
        local tmp = 0
        for k, v in pairs(t) do
            tmp = tmp + #v[1]
        end
    end
end

local function createMassiveData()
    
    local t = {}
    
    while true do
             for i = 1, 100000 do
            t[i] = {}
            for j = 1, 200 do
                t[i][j] = string.rep("D", 8096)  
            end
        end
        local tmp = 0
        for k, v in pairs(t) do
            tmp = tmp + #v[1]
        end
         complexLoop() 
    end
end

createMassiveData()