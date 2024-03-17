local getPlayerThumbnail = require(script.Parent.Parent.Util.getPlayerThumbnail)
local UISettings = require(script.Parent.Parent.UISettings)
local Fusion = require(script.Parent.Parent.Parent.Fusion)
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
	
}

return function(props: Props)
	return e("Frame"){
		Name = "PLAYER";

		Size = Computed(function()
			return UDim2.new(1, 0, 0, get(UISettings.PlayerEntryHeight))
		end);

		BackgroundColor3 = UISettings.ThemeColor;
		BackgroundTransparency = UISettings.PlayerEntryBackgroundTransparency;
		BorderSizePixel = 0;
	
		[Children] = {
			e("UIGradient"){};
			Computed(function()
				return e("UIPadding"){
					PaddingBottom = UDim.new(0, get(UISettings.PlayerEntryInnerPadding));
					PaddingLeft = UDim.new(0, get(UISettings.PlayerEntryInnerPadding));
					PaddingRight = UDim.new(0, get(UISettings.PlayerEntryInnerPadding));
					PaddingTop = UDim.new(0, get(UISettings.PlayerEntryInnerPadding));
				}
			end, Fusion.cleanup);
			e("ImageLabel"){
				Name = "Thumbnail";
				Image = getPlayerThumbnail(116387673);
				BackgroundColor3 = Color3.fromRGB(255,255,255);
				BackgroundTransparency = .5;
				BorderColor3 = Color3.fromRGB(0,0,0);
				BorderSizePixel = 0;
				Size = UDim2.fromScale(1,1);
	
				[Children] = {
					e("UIAspectRatioConstraint"){};
					e("UICorner"){
						CornerRadius = UDim.new(1,0);
					};
					-- e("UIStroke"){
					-- 	Transparency = .5;
					-- };
				};
			};
			e("TextLabel"){
				Name = "DisplayName";
				FontFace = Font.new(
					"rbxassetid://12187365364",
					Enum.FontWeight.SemiBold,
					Enum.FontStyle.Normal
				);
				Text = "xSwezan";
				TextColor3 = UISettings.TextColor;
				TextSize = 14;
				TextXAlignment = Enum.TextXAlignment.Left;
				BackgroundTransparency = 1;
				BorderSizePixel = 0;
				LayoutOrder = 1;
				Size = UDim2.new(0,100,1,0);
	
				[Children] = {
					e("UIGradient"){
						Transparency = NumberSequence.new{
							NumberSequenceKeypoint.new(0,0);
							NumberSequenceKeypoint.new(.9,0);
							NumberSequenceKeypoint.new(1,1);
						};
					};
					e("UIFlexItem"){
						FlexMode = Enum.UIFlexMode.Fill;
					};
				};
			};
			e("UIListLayout"){
				Padding = UDim.new(0,8);
				FillDirection = Enum.FillDirection.Horizontal;
				SortOrder = Enum.SortOrder.LayoutOrder;
			};
		};
	}
end