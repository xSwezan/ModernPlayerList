local Fusion = require(script.Parent.Parent.Fusion)
local FusionTypes = require(script.Parent.FusionTypes)

export type Global = {
	HeaderStatWidths: {[string]: FusionTypes.StateObject<number>};
	RegisteredActions: FusionTypes.Value<{[string]: Action}>;
	ActionOrder: {string};
}

export type Action = {
	Name: string;
	Info: ActionInfo;
	Callback: (Player: Player) -> nil;
}

export type ActionInfo = {
	Text: string;
	Icon: string?;
	Color: Color3?;
}

local Global: Global = {
	HeaderStatWidths = {};
	RegisteredActions = Fusion.Value{};
	ActionOrder = {};
}

return Global