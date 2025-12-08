local addonName, addon = ...

local AceConfigDialog = LibStub("AceConfigDialog-3.0")
local AceConfigRegistry = LibStub("AceConfigRegistry-3.0")

local L = LibStub("AceLocale-3.0"):GetLocale(addonName)

local defaults = {
    profile = {
        timeout = 10,
        moveLimit = 3,
        enableSituations = {
            solo = false,
            party = false,
            raid10 = true,
            raid25 = true,
            raid40 = false,
            battleground = false,
            arena = false,
        },
    }
}

local options = {
    type = "group",
    set = function(info, value) addon.db.profile[info[#info]] = value end,
    get = function(info) return addon.db.profile[info[#info]] end,
    args = {
        timeout = {
            name = L["TIMEOUT"],
            desc = L["TIMEOUT_DESC"],
            type = "range",
            min = 1,
            max = 60,
            step = 1,
        },
        moveLimit = {
            name = L["MOVELIMIT"],
            desc = L["MOVELIMIT_DESC"],
            type = "range",
            min = 1,
            max = 100,
            softMax = 5,
            step = 1,
        },
        enableSituations = {
            type = "multiselect",
            name = ENABLE,
            values = {
                solo = SOLO,
                party = PARTY,
                raid10 = RAID.."(10)",
                raid25 = RAID.."(25)",
                raid40 = RAID.."(40)",
                battleground = BATTLEGROUND,
                arena = ARENA,
            },
            get = function(_, keyName) return addon.db.profile.enableSituations[keyName] end,
            set = function(_, keyName, state) addon.db.profile.enableSituations[keyName] = state end,
        },
    },
}

EventUtil.ContinueOnAddOnLoaded(addonName, function()
    addon.db = LibStub("AceDB-3.0"):New("DontReleaseDB", defaults)
            
    AceConfigRegistry:RegisterOptionsTable(addonName, options)
    AceConfigDialog:AddToBlizOptions(addonName)
end)
