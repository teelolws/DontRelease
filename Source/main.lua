local addonName, addon = ...

local L = LibStub("AceLocale-3.0"):GetLocale(addonName)

local firstEnterTime
local numMoves = 0

for i = 1, 4 do
    _G["StaticPopup"..i]:HookScript("OnShow", function(self)
        firstEnterTime = nil
        numMoves = 0
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
            
            if point == "TOP" then
                local left, right, up, down
                local x = (screenWidth/2) - (width/2) + offsetX
                local y = screenHeight + offsetY
                
                local num = 0
                local f = {}
                if x - width > 0 then
                    num = num + 1
                    f[num] = function()
                        offsetX = offsetX - width
                    end
                end
                if x + width + width < screenWidth then
                    num = num + 1
                    f[num] = function()
                        offsetX = offsetX + width
                    end
                end
                if y - height > 0 then
                    num = num + 1
                    f[num] = function()
                        offsetY = offsetY - height
                    end
                end
                if y + height + height < screenHeight then
                    num = num + 1
                    f[num] = function()
                        offsetY = offsetY + height
                    end
                end
                
                local rand = math.random(1, num)
                f[rand]()
                self:SetPoint(point, relativeTo, relativePoint, offsetX, offsetY)
            end
        end
    end)
end