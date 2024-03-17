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
	Icon: FusionTypes.CanBeState<string>?;
	Color: FusionTypes.CanBeState<Color3>?;

	OnClick: () -> nil?;

	props: {[any]: FusionTypes.CanBeState<any>}?;
}

return function(props: Props)
	local Text = getter(props.Text, "Action")
	local Icon = getter(props.Icon, "rbxassetid://16756274878")
	local Color = getter(props.Color, Color3.fromRGB(255,255,255))

	local Hovering = Value(false)
	local HoverAlpha = Spring(Computed(function()
		return if (Hovering:get()) then 1 else 0
	end), 50, 1)

	return Hydrate(e("ImageButton"){
		Name = "ActionButton";

		Size = Computed(function()
			return UDim2.new(1, 0, 0, get(UISettings.ActionButtonHeight))
		end);

		BackgroundColor3 = Computed(function()
			return get(UISettings.ThemeColor):Lerp(get(UISettings.ActionButtonHoverColor), HoverAlpha:get())
		end);
		BackgroundTransparency = UISettings.PlayerEntryBackgroundTransparency;
		BorderSizePixel = 0;

		Image = "";

		[OnEvent("MouseEnter")] = function()
			Hovering:set(true)
		end;
		[OnEvent("MouseLeave")] = function()
			Hovering:set(false)
		end;

		[OnEvent("MouseButton1Down")] = props.OnClick;
	
		[Children] = {
			Computed(function()
				return e("UIPadding"){
					PaddingBottom = UDim.new(0, get(UISettings.ActionButtonInnerPadding));
					PaddingLeft = UDim.new(0, get(UISettings.ActionButtonInnerPadding));
					PaddingRight = UDim.new(0, get(UISettings.ActionButtonInnerPadding));
					PaddingTop = UDim.new(0, get(UISettings.ActionButtonInnerPadding));
				}
			end, Fusion.cleanup);
			Computed(function()
				if not (Icon:get()) then return end

				return e("ImageLabel"){
					Name = "Icon";
	
					Size = Computed(function()
						return UDim2.fromOffset(get(UISettings.ActionButtonIconSize), get(UISettings.ActionButtonIconSize))
					end);
	
					BackgroundTransparency = 1;
					BorderSizePixel = 0;
					
					Image = Icon;
					ImageColor3 = Color;
					ScaleType = Enum.ScaleType.Fit;
				};
			end, Fusion.cleanup);
			e("TextLabel"){
				Name = "ActionText";

				AutomaticSize = Enum.AutomaticSize.XY;
				
				Text = Text;
				TextColor3 = Color;
				TextSize = 14;
				TextXAlignment = Enum.TextXAlignment.Left;
				FontFace = Computed(function()
					return Font.new(
						get(UISettings.FontFamily),
						Enum.FontWeight.Bold,
						Enum.FontStyle.Normal
					)
				end);

				BackgroundTransparency = 1;
				BorderSizePixel = 0;

				LayoutOrder = 1;

				[Children] = {
					e("UIFlexItem"){
						FlexMode = Enum.UIFlexMode.Fill;
					};
				}
			};
			e("UIListLayout"){
				Padding = UDim.new(0, 10);
				FillDirection = Enum.FillDirection.Horizontal;
				SortOrder = Enum.SortOrder.LayoutOrder;
				VerticalAlignment = Enum.VerticalAlignment.Center;
			};
		};
	})(props.props or {})
end