local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")

local player = Players.LocalPlayer

-- Точки телепортации
local teleportPoints = {
    Vector3.new(172.26, 47.47, 426.68),
    Vector3.new(170.43, 3.66, 474.95)
}

-- Функция моментальной телепортации
local function instantTeleport(targetPosition)
    local character = player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then 
        return false
    end
    
    local rootPart = character.HumanoidRootPart
    rootPart.CFrame = CFrame.new(targetPosition)
    return true
end

-- Функция проверки достижения точки
local function isAtPosition(targetPosition, threshold)
    local character = player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then 
        return false
    end
    
    local rootPart = character.HumanoidRootPart
    local distance = (rootPart.Position - targetPosition).Magnitude
    return distance < threshold
end

-- Основной процесс автоматической телепортации
local function startAutoTeleportProcess()
    -- Ждем появления персонажа
    local character = player.Character or player.CharacterAdded:Wait()
    
    -- Минимальная задержка перед началом
    wait(0.5)
    
    -- Телепортация по всем точкам
    for index, point in ipairs(teleportPoints) do
        print("Телепортация на точку " .. index)
        
        -- Пытаемся телепортироваться
        local success = instantTeleport(point)
        
        if success then
            -- Краткая проверка успешности телепортации
            local confirmed = false
            for i = 1, 10 do  -- 10 попыток по 0.1 секунды = 1 секунда максимум
                wait(0.1)
                if isAtPosition(point, 5) then
                    confirmed = true
                    break
                end
            end
            
            if confirmed then
                print("Успешная телепортация на точку " .. index)
                -- Мгновенный перезаход после успешной телепортации
                print("Мгновенный перезаход...")
                TeleportService:Teleport(game.PlaceId, player)
                return  -- Выходим из функции, так как начался процесс телепортации
            else
                print("Не удалось подтвердить телепортацию на точку " .. index)
                -- Продолжаем со следующей точкой
            end
        else
            print("Ошибка телепортации на точку " .. index)
        end
    end
    
    -- Если все точки пройдены без успешной телепортации, все равно перезаходим
    print("Перезаход после попыток всех телепортаций...")
    TeleportService:Teleport(game.PlaceId, player)
end

-- Запускаем процесс когда игрок загрузится
if player then
    startAutoTeleportProcess()
else
    Players.PlayerAdded:Connect(function(newPlayer)
        if newPlayer == player then
            startAutoTeleportProcess()
        end
    end)
end

-- Обработка респавна персонажа
player.CharacterAdded:Connect(function(character)
    -- Если процесс уже запущен, не делаем ничего
end)

print("Автоматическая система телепортации с мгновенным перезаходом активирована")
