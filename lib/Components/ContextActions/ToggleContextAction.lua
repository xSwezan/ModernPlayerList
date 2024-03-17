local ReplicatedStorage = game:GetService("ReplicatedStorage")
local FusionTypes = require(ReplicatedStorage.lib.lib.FusionTypes)
local Fusion = require(script.Parent.Parent.Parent.Parent.Fusion)
local UISettings = require(script.Parent.Parent.Parent.UISettings)
local get = require(script.Parent.Parent.Parent.Util.get)

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
	Toggled: FusionTypes.Value<boolean>;

	props: {[any]: FusionTypes.CanBeState<any>}?;
	TextProps: {[any]: FusionTypes.CanBeState<any>}?;
}

return function(props: Props)
	local Hovering = Value(false)
	local HoverAlpha = Spring(Computed(function()
		return if (Hovering:get()) then 1 else 0
	end), 50, 1)

	return Hydrate(e("ImageButton"){
		Name = "ToggleContextAction";

		AutomaticSize = Enum.AutomaticSize.X;
		Size = Computed(function()
			return UDim2.new(1, 0, 0, get(UISettings.ContextActionHeight))
		end);

		BackgroundColor3 = Computed(function()
			return get(UISettings.ThemeColor):Lerp(get(UISettings.ActionButtonHoverColor), HoverAlpha:get())
		end);
		BackgroundTransparency = UISettings.ContextActionBackgroundTransparency;
		BorderSizePixel = 0;

		[OnEvent("MouseEnter")] = function()
			Hovering:set(true)
		end;
		[OnEvent("MouseLeave")] = function()
			Hovering:set(false)
		end;

		[OnEvent("MouseButton1Down")] = function()
			props.Toggled:set(not props.Toggled:get())
		end;
	
		[Children] = {
			e("UIListLayout"){
				Padding = Computed(function()
					return UDim.new(0, get(UISettings.Padding))
				end);
				FillDirection = Enum.FillDirection.Horizontal;
				SortOrder = Enum.SortOrder.LayoutOrder;
				VerticalAlignment = Enum.VerticalAlignment.Center;
			};
			Computed(function()
				return e("UIPadding"){
					PaddingBottom = UDim.new(0, get(UISettings.ContextMenuInnerPadding));
					PaddingLeft = UDim.new(0, get(UISettings.ContextMenuInnerPadding));
					PaddingRight = UDim.new(0, get(UISettings.ContextMenuInnerPadding));
					PaddingTop = UDim.new(0, get(UISettings.ContextMenuInnerPadding));
				}
			end, Fusion.cleanup);
			Hydrate(e("TextLabel"){
				Name = "Label";

				AutomaticSize = Enum.AutomaticSize.X;
				Size = UDim2.fromScale(0,1);

				BackgroundTransparency = 1;
				BorderSizePixel = 0;

				Text = "ActionText";
				TextColor3 = Color3.fromRGB(255,255,255);
				TextSize = 12;
				TextXAlignment = Enum.TextXAlignment.Left;
				FontFace = Computed(function()
					return Font.new(
						get(UISettings.FontFamily),
						Enum.FontWeight.SemiBold,
						Enum.FontStyle.Normal
					)
				end);

				[Children] = {
					e("UIFlexItem"){
						FlexMode = Enum.UIFlexMode.Fill;
					};
				}
			})(props.TextProps or {});
			e("Frame"){
				Name = "Checkbox";

				Size = UDim2.fromOffset(10,10);

				BackgroundColor3 = Color3.fromRGB(56,56,56);
				BorderSizePixel = 0;

				LayoutOrder = 1;
	
				[Children] = {
					e("UICorner"){
						CornerRadius = UDim.new(0,2);
					};
					e("ImageLabel"){
						Size = UDim2.fromScale(.9,.9);

						Position = UDim2.fromScale(.5,.5);
						AnchorPoint = Vector2.new(.5,.5);

						BackgroundTransparency = 1;
						BorderSizePixel = 0;

						Image = "rbxassetid://16779771410";
						ImageColor3 = Color3.fromRGB(130,130,130);
						ScaleType = Enum.ScaleType.Fit;

						Visible = props.Toggled;
					};
				};
			};
		};
	})(props.props or {})
end