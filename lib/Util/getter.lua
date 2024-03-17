local Fusion = require(script.Parent.Parent.Parent.Fusion)
local FusionTypes = require(script.Parent.Parent.FusionTypes)
local get = require(script.Parent.get)

return function<T>(Value: FusionTypes.CanBeState<T>, Or: any?): FusionTypes.Computed<T>
	return Fusion.Computed(function()
		local Output: T = get(Value)
		return if (Output == nil) then Or else Output
	end, Fusion.doNothing)
end