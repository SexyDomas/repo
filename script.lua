--[[
KeyBinds = {
    Turn on ESP = Y,
    Turn off ESP = U 
}
]]--

for i,v in pairs(getconnections(game:GetService("ScriptContext").Error)) do 
    v:Disable()
end

if getgenv().ESPTOGGLE1 then 
    getgenv().ESPTOGGLE1 = nil
end
getgenv().ESPTOGGLE1 = true
local ToggleKey = Enum.KeyCode.Y
local HideCommonToggleKey = Enum.KeyCode.U
local Meshes = {
    ["rbxassetid://16657069"] = "Money Bag",
    ["rbxassetid://60791940"] = "Scroll",
    ["rbxassetid://2877143560"] = "Gem",
    ["rbxassetid://2637545558"] = "Ring",
    ["rbxassetid://439102658"] = "Phoenix Feather",
    ["rbxassetid://13116112"] = "Goblet",
    ["rbxassetid://5196577540"] = "Amulet",
    ["rbxassetid://5204003946"] = "Goblet",
    ["rbxassetid://5204453430"] = "Scroll",
    ["rbxassetid://5196782997"] = "Old Ring",
    ["rbxassetid://%2016657069%20"] = "Money Bag",
    ["rbxassetid://%2060791940%20"] = "Scroll",
    ["rbxassetid://%202877143560%20"] = "Gem",
    ["rbxassetid://%202637545558%20"] = "Ring",
    ["rbxassetid://%20439102658%20"] = "Phoenix Feather",
    ["rbxassetid://%2013116112%20"] = "Goblet",
    ["rbxassetid://%205196577540%20"] = "Amulet",
    ["rbxassetid://%205204003946%20"] = "Goblet",
    ["rbxassetid://%205204453430%20"] = "Scroll",
    ["rbxassetid://%205196782997%20"] = "Old Ring",
    ["rbxassetid://5196776695"] = "Ring",
    ["rbxassetid://%205196776695%20"] = "Ring",

}

local RefreshRate = 14 --In miliseconds, change if your laggy
local wrksp = game:GetService("Workspace");
local Camera = wrksp.CurrentCamera;
local WTVP = Camera.WorldToViewportPoint;
local IsDescendantOf = game.IsDescendantOf;
local Vec2 = Vector2.new(0, 15);
local strformat = string.format;


function WTS(Position)
    local VP,bool = WTVP(Camera,Position)
    return Vector2.new(VP.x, VP.y),bool,VP.Z
end

function CreateESP(Character, Class)
    local LastRefresh = 0;
    if not Character then
        return
    end
    
    local PName = Character.Name;
    local Name = Drawing.new("Text")
    Name.Text = Character.Name;
    Name.Color = Color3.fromRGB(141, 255, 126)
    Name.Position = WTS(Character.Position);
    Name.Size = 18
    Name.Outline = true
    Name.Center = true
    Name.Visible = true
    Name.Font = 0
    local Bottom = Drawing.new("Text")
    Bottom.Color = Color3.fromRGB(192,192,192)
    Bottom.Position = WTS(Character.Position) + Vec2;
    Bottom.Size = 18
    Bottom.Outline = true
    Bottom.Center = true
    Bottom.Visible = true
    Bottom.Font = 0
    
    pcall(function()
        if Character.Parent:IsA("MeshPart") and Meshes[Character.Parent.MeshId]  then 
            Name.Text = tostring(Meshes[Character.Parent.MeshId]) 
        elseif Character.Parent:IsA("Part") and Character.Parent:FindFirstChildWhichIsA("SpecialMesh") and Meshes[Character.Parent:FindFirstChildWhichIsA("SpecialMesh").MeshId] then
            Name.Text = tostring(Meshes[Character.Parent:FindFirstChildWhichIsA("SpecialMesh").MeshId])
        elseif Character.Parent:IsA("Part") and Character.Parent:FindFirstChildWhichIsA("SpecialMesh") and Character.Parent:FindFirstChild("OrbParticle") then
            Name.Text = tostring("???")
        else
            Name.Text = tostring("Opal")
        end
    end)

    local Con;
    Con = game:GetService("RunService").RenderStepped:Connect(function() --Update if on screen.
        if (tick() - LastRefresh) > (RefreshRate / 1000) then
            LastRefresh = tick();
            if not IsDescendantOf(Character,workspace) and Name ~= nil and Bottom ~= nil then
                Con:Disconnect();
                Con = nil; 
                Name:Remove()
                Bottom:Remove()
                return 
            end
            local HRPP = Character.Position;
            local Pos,Bool,Distance = WTS(HRPP);
            if Bool and getgenv().ESPTOGGLE1 then
                Bottom.Text = strformat('[%d]',Distance)
                Name.Position = Pos;
                Bottom.Position = Pos + Vec2;
                Name.Visible = true;
                Bottom.Visible = true;
            else
                Name.Visible = false;
                Bottom.Visible = false;
            end
        end
    end)
end



for i,v in pairs(wrksp:GetChildren()) do 
    if v:IsA("MeshPart") or v:IsA("UnionOperation") or v:IsA("Part") then 
        for i2,v2 in pairs(v:GetDescendants()) do 
            if v2:IsA("ClickDetector") then 
                CreateESP(v2.Parent)
            end
        end
    end
end

wrksp.ChildAdded:Connect(function(v)
    if v:IsA("MeshPart") or v:IsA("UnionOperation") or v:IsA("Part") then 
        for i2,v2 in pairs(v:GetDescendants()) do 
            if v2:IsA("ClickDetector") then 
                CreateESP(v2.Parent)
            end
        end
    end
end)


game:GetService("UserInputService").InputBegan:Connect(function(inputObject, gameProcessed)
    if inputObject.KeyCode == ToggleKey then
        getgenv().ESPTOGGLE1 = true
    elseif inputObject.KeyCode == HideCommonToggleKey then
        getgenv().ESPTOGGLE1 = false
    end
end)
