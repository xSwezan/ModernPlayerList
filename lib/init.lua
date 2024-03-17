--[[
	
TODO: Add Ordering Stats
-	Add a child BoolValue named IsPrimary to the stat and set its value to true to place the stat first in the leaderboard.
-	Add a child NumberValue named Priority to the stat and set its value to an integer.
	Higher priority values appear earlier in the leaderboard. Stats without a priority have a default priority of 0.

--]]

local Players = game:GetService("Players")
local UISettings = require(script.UISettings)
local Global = require(script.Global)

local Player: Player = Players.LocalPlayer
local PlayerGui: PlayerGui = Player:WaitForChild("PlayerGui") :: PlayerGui

export type ModernPlayerList = {
	Load: (self: ModernPlayerList, Settings: UISettings.Settings?) -> nil;
	SetSettings: (self: ModernPlayerList, Settings: UISettings.Settings) -> nil;
	AddAction: (self: ModernPlayerList, Name: string, Info: Global.ActionInfo, RunClient: (Player: Player) -> nil) -> nil;
	RemoveAction: (self: ModernPlayerList, Name: string) -> nil;
}

if (game:GetService("RunService"):IsServer()) then
	warn("Modern Player List can only be required on the client!")
	return {} :: ModernPlayerList
end

local MPL = {}

function MPL:Load(Settings: UISettings.Settings?)
	if (Settings) then
		MPL:SetSettings(Settings)
	end

	local App: ScreenGui = require(script.Components.App){}
	App.Parent = PlayerGui
end

function MPL:SetSettings(Settings: UISettings.Settings)
	for Key: string, Value: any in pairs(Settings) do
		UISettings[Key]:set(Value)
	end
end

function MPL:AddAction(Name: string, Info: Global.ActionInfo, RunClient: (Player: Player) -> nil)
	local NewAction: Global.Action = {
		Name = Name;
		Info = Info;
		Callback = RunClient;
	}

	local Index: number? = table.find(Global.ActionOrder, Name)
	if (Index) then
		table.remove(Global.ActionOrder, Index)
	end
	table.insert(Global.ActionOrder, Name)

	local Actions: {[string]: Global.Action} = Global.RegisteredActions:get()
	Actions[Name] = NewAction
	Global.RegisteredActions:set(Actions)
end

function MPL:RemoveAction(Name: string)
	local Actions: {[string]: Global.Action} = Global.RegisteredActions:get()
	Actions[Name] = nil
	Global.RegisteredActions:set(Actions)

	local Index: number? = table.find(Global.ActionOrder, Name)
	if (Index) then
		table.remove(Global.ActionOrder, Index)
	end
end

return MPL :: ModernPlayerList