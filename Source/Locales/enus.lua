local addonName, addon = ...
local L = LibStub("AceLocale-3.0"):NewLocale(addonName, "enUS", true)
if not L then return end

L["TIMEOUT"] = "Timeout"
L["TIMEOUT_DESC"] = "Number of seconds after you first move the Dialog box before the Dialog will stop moving away"
L["MOVELIMIT"] = "Move limit"
L["MOVELIMIT_DESC"] = "Number of times the Dialog Box will move away before it stops moving"