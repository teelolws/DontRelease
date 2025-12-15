local addonName, addon = ...

local TICKER_FREQUENCY = 0.001
local TICKER_STEPS = 4

local firstEnterTime
local numMoves = 0
local ticker

local function startTicker(frame, numSteps, direction)
    if ticker then
        ticker:Cancel()
    end
    
    ticker = C_Timer.NewTicker(TICKER_FREQUENCY, function()
        if numSteps < 0 then
            ticker:Cancel()
            ticker = nil
            return
        end
        
        point, relativeTo, relativePoint, offsetX, offsetY = frame:GetPoint()
        if direction == 1 then
            frame:SetPoint(point, relativeTo, relativePoint, offsetX-TICKER_STEPS, offsetY)
        elseif direction == 2 then
            frame:SetPoint(point, relativeTo, relativePoint, offsetX+TICKER_STEPS, offsetY)
        elseif direction == 3 then
            frame:SetPoint(point, relativeTo, relativePoint, offsetX, offsetY+TICKER_STEPS)
        elseif direction == 4 then
            frame:SetPoint(point, relativeTo, relativePoint, offsetX, offsetY-TICKER_STEPS)
        end
        
        numSteps = numSteps - TICKER_STEPS
    end)
end

for i = 1, 4 do
    _G["StaticPopup"..i]:HookScript("OnShow", function(self)
        firstEnterTime = nil
        numMoves = 0
        if ticker then
            ticker:Cancel()
            ticker = nil
        end
    end)
    
    _G["StaticPopup"..i]:HookScript("OnUpdate", function(self)
        if self.which == "DEATH" and self:IsMouseOver() then
            local enableSituations = addon.db.profile.enableSituations
            
            if C_PvP.IsArena() then
                if not enableSituations.arena then return end
            elseif C_PvP.IsBattleground() then
                if not enableSituations.battleground then return end
            else
                if IsInRaid() then
                    local raidSize = GetNumGroupMembers()
                    if raidSize < 11 then
                        if not enableSituations.raid10 then return end
                    elseif raidSize < 26 then
                        if not enableSituations.raid25 then return end
                    else
                        if not enableSituations.raid40 then return end
                    end
                elseif IsInGroup() then
                    if not enableSituations.party then return end
                else
                    if not enableSituations.solo then return end
                end
            end
            
            if firstEnterTime and (firstEnterTime + addon.db.profile.timeout < GetTime()) then return end
            if not firstEnterTime then
                firstEnterTime = GetTime()
            end
            
            numMoves = numMoves + 1
            if numMoves > addon.db.profile.moveLimit then return end

            local width, height = self:GetSize()
            local screenWidth, screenHeight = UIParent:GetSize()
            local point, relativeTo, relativePoint, offsetX, offsetY = self:GetPoint()
            local lockoutLeft, lockoutRight, lockoutUp, lockoutDown
            
            if point ~= "TOP" then return end
            
            local x = (screenWidth/2) - (width/2) + offsetX
            local y = screenHeight + offsetY
            
            local num = 0
            local f = {}
            if x - width < 0 then
                lockoutLeft = true
            end
            if x + width + width > screenWidth then
                lockoutRight = true
            end
            if y - height < 0 then
                lockoutDown = true
            end
            if y + height + height > screenHeight then
                lockoutUp = true
            end
            
            local rand = math.random(1, 2)
            local direction -- left: 1, right: 2, up: 3, down: 4

        
            local halfHeight, halfWidth = height/2, width/2
            
            -- is cursor in top left quadrant?
            if self:IsMouseOver(nil, halfHeight, nil, -1*halfWidth) then
                if lockoutRight and lockoutDown then
                    direction = rand
                    if direction == 2 then
                        direction = 3
                    end
                elseif lockoutRight then
                    direction = 4
                elseif lockoutDown then
                    direction = 2
                else
                    if rand == 1 then
                        direction = 2
                    else
                        direction = 4
                    end
                end
                
            -- topright?
            elseif self:IsMouseOver(nil, halfHeight, halfWidth, nil) then
                if lockoutLeft and lockoutDown then
                    if rand == 1 then
                        direction = 2
                    else
                        direction = 3
                    end
                elseif lockoutLeft then
                    direction = 4
                elseif lockoutDown then
                    direction = 1
                else
                    if rand == 1 then
                        direction = 1
                    else
                        direction = 4
                    end
                end
            -- bottomleft?
            elseif self:IsMouseOver(-1*halfHeight, nil, nil, -1*halfWidth) then
                if lockoutRight and lockoutUp then
                    if rand == 1 then
                        direction = 4
                    else
                        direction = 1
                    end
                elseif lockoutRight then
                    direction = 3
                elseif lockoutUp then
                    direction = 2
                else
                    if rand == 1 then
                        direction = 2
                    else
                        direction = 3
                    end
                end
            -- bottomright?
            elseif self:IsMouseOver(-1*halfHeight, nil, halfWidth, nil) then
                if lockoutLeft and lockoutUp then
                    if rand == 1 then
                        direction = 2
                    else
                        direction = 4
                    end
                elseif lockoutLeft then
                    direction = 3
                elseif lockoutUp then
                    direction = 1
                else
                    if rand == 1 then
                        direction = 1
                    else
                        direction = 3
                    end
                end
            end
        
            if direction == 1 then
                startTicker(self, halfWidth, direction)
                offsetX = offsetX - halfWidth
            elseif direction == 2 then
                startTicker(self, halfWidth, direction)
                offsetX = offsetX + halfWidth
            elseif direction == 3 then
                startTicker(self, halfHeight, direction)
                offsetY = offsetY + halfHeight
            elseif direction == 4 then
                startTicker(self, halfHeight, direction)
                offsetY = offsetY - halfHeight
            else
                return
            end
            
            
            self:SetPoint(point, relativeTo, relativePoint, offsetX, offsetY)
        end
    end)
end