local Fusion = require(script.Parent.Parent.Parent.Fusion)
local FusionTypes = require(script.Parent.Parent.FusionTypes)

return function(Object: Instance, Name: string): (FusionTypes.Value<any>, () -> nil)
	local Value = Fusion.Value(Object[Name])

	local Connection: RBXScriptConnection = Object:GetPropertyChangedSignal(Name):Connect(function()
		Value:set(Object[Name])
	end)

	return Value, function()
		if not (Connection.Connected) then return end

		Connection:Disconnect()
	end
end