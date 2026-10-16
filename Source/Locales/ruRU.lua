local addonName = ...
local L = LibStub("AceLocale-3.0"):NewLocale(addonName, "ruRU")
if not L then return end
-- Translator ZamestoTV
L["TIMEOUT"] = "Время ожидания"
L["TIMEOUT_DESC"] = "Количество секунд после первого перемещения диалогового окна, по истечении которых оно перестанет улетать"
L["MOVELIMIT"] = "Лимит перемещений"
L["MOVELIMIT_DESC"] = "Количество раз, которое диалоговое окно может улететь, прежде чем оно остановится"
