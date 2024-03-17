local ReplicatedStorage = game:GetService("ReplicatedStorage")
local FusionTypes = require(ReplicatedStorage.lib.lib.FusionTypes)
local Fusion = require(script.Parent.Parent.Parent.Fusion)
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
	Width: FusionTypes.CanBeState<number>?;
	
	props: {[any]: FusionTypes.CanBeState<any>}?;
}

return function(props: Props)
	local Width = getter(props.Width, get(UISettings.MinStatWidth))

	return Hydrate(e("TextLabel"){
		Name = "StatLabel";

		-- Size = UDim2.new(0, 50, 1, 0); --> Make this the same width as the StatCategory Label in the Header
		Size = Computed(function()
			return UDim2.new(0, Width:get(), 1, 0)
		end);

		FontFace = Computed(function()
			return Font.new(
				get(UISettings.FontFamily),
				Enum.FontWeight.Bold,
				Enum.FontStyle.Normal
			)
		end);
		Text = "10M+";
		TextColor3 = Color3.fromRGB(255,255,255);
		TextSize = 14;
		BackgroundTransparency = 1;
		BorderSizePixel = 0;
		LayoutOrder = 1;

		-- [Children] = {
		-- 	Computed(function()
		-- 		local Padding: number = get(UISettings.StatInnerPadding)
		-- 		if (Padding == 0) then return end

		-- 		return e("UIPadding"){
		-- 			PaddingRight = UDim.new(0, Padding);
		-- 			PaddingLeft = UDim.new(0, Padding);
		-- 		}
		-- 	end, Fusion.cleanup);
		-- }
	})(props.props or {})
end