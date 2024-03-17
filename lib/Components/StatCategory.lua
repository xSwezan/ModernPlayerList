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
	Text: FusionTypes.CanBeState<string>?;
	Color: FusionTypes.CanBeState<Color3>?;

	props: {[any]: FusionTypes.CanBeState<any>}?;
}

return function(props: Props): TextLabel
	local Text = getter(props.Text, "Stat")
	local Color = getter(props.Color, Color3.fromRGB(255,255,255))

	return Hydrate(e("TextLabel"){
		Name = "StatCategory";

		AutomaticSize = Enum.AutomaticSize.X;
		Size = Computed(function()
			return UDim2.new(0, get(UISettings.MinStatWidth), 1, 0)
		end);

		BackgroundTransparency = 1;
		BorderSizePixel = 0;

		Text = Text;
		TextColor3 = Color;
		TextSize = 12;
		FontFace = Computed(function()
			return Font.new(
				get(UISettings.FontFamily),
				Enum.FontWeight.SemiBold,
				Enum.FontStyle.Normal
			)
		end);

		LayoutOrder = 1;

		[Children] = {
			Computed(function()
				local Padding: number = get(UISettings.StatInnerPadding)
				if (Padding == 0) then return end

				return e("UIPadding"){
					PaddingRight = UDim.new(0, Padding);
					PaddingLeft = UDim.new(0, Padding);
				}
			end, Fusion.cleanup);
		}
	})(props.props or {})
end