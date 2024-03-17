local UserInputService = game:GetService("UserInputService")
local Fusion = require(script.Parent.Parent.Parent.Fusion)
local FusionTypes = require(script.Parent.Parent.FusionTypes)
local UISettings = require(script.Parent.Parent.UISettings)
local getter = require(script.Parent.Parent.Util.getter)
local get = require(script.Parent.Parent.Util.get)

local e = Fusion.New
local Children = Fusion.Children
local Cleanup = Fusion.Cleanup
local Hydrate = Fusion.Hydrate
local Out = Fusion.Out
local Ref = Fusion.Ref
local Value = Fusion.Value
local OnEvent = Fusion.OnEvent
local OnChange = Fusion.OnChange
local Computed = Fusion.Computed
local Observer = Fusion.Observer
local Tween = Fusion.Tween
local Spring = Fusion.Spring
local ForPairs = Fusion.ForPairs
local ForKeys = Fusion.ForKeys
local ForValues = Fusion.ForValues

export type Props = {
	props: {[any]: FusionTypes.CanBeState<any>}?;

	OnClickOutside: () -> nil?;
}

return function(props: Props)
	local Hovering = Value(false)

	return Hydrate(e("CanvasGroup"){
		Name = "ContextMenu";

		AutomaticSize = Enum.AutomaticSize.XY;

		AnchorPoint = Vector2.new(0,0);
		Position = UDim2.fromScale(.5,.5);
		
		BackgroundTransparency = 1;
		BorderSizePixel = 0;

		ZIndex = 10;

		[OnEvent("MouseEnter")] = function()
			Hovering:set(true)
		end;
		[OnEvent("MouseLeave")] = function()
			Hovering:set(false)
		end;

		[Cleanup] = {
			UserInputService.InputBegan:Connect(function(Input: InputObject, GP: boolean)
				if (Hovering:get()) then return end

				if (Input.UserInputType == Enum.UserInputType.MouseButton1) or (Input.UserInputType == Enum.UserInputType.MouseButton2) then
					if (type(props.OnClickOutside) == "function") then
						props.OnClickOutside()
					end
				end
			end);
		};
	
		[Children] = {
			e("UICorner"){};
			e("UIListLayout"){
				Padding = UDim.new(0,1);
				SortOrder = Enum.SortOrder.LayoutOrder;
			};
			e("UISizeConstraint"){
				MinSize = Computed(function()
					return Vector2.new(get(UISettings.ContextActionHeight), 0)
				end);
			};
		};
	})(props.props or {})
end