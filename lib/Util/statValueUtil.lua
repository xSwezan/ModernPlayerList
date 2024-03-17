local findFirst = require(script.Parent.findFirst)
local FusionTypes = require(script.Parent.Parent.FusionTypes)
local recordAttribute = require(script.Parent.recordAttribute)
local recordProperty = require(script.Parent.recordProperty)

local Util = {}

-- Checks for Color attribute, and if no attribute found it checks for a 'Color' Color3Value. Returns white if nothing was found.
function Util.getColor(Value: ValueBase): Color3?
	local Color: Color3?

	local Attribute: Color3 = Value:GetAttribute("Color")
	if (Attribute) then
		Color = Attribute
	else
		local ColorValue: Color3Value? = findFirst(Value, "Color", "Color3Value") :: Color3Value?
		if (ColorValue) then
			Color = ColorValue.Value
		end
	end

	return Color
end

function Util.getColorState(Value: ValueBase): FusionTypes.StateObject<Color3>?
	local Color: FusionTypes.StateObject<Color3>?

	local Attribute: Color3 = Value:GetAttribute("Color")
	if (Attribute) then
		Color = recordAttribute(Value, "Color")
	else
		local ColorValue: Color3Value? = findFirst(Value, "Color", "Color3Value") :: Color3Value?
		if (ColorValue) then
			Color = recordProperty(ColorValue, "Value")
		end
	end

	return Color
end

return Util