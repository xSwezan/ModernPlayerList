local getPlayerThumbnail = require(script.Parent.Parent.Util.getPlayerThumbnail)
local UISettings = require(script.Parent.Parent.UISettings)
local Global = require(script.Parent.Parent.Global)
local Fusion = require(script.Parent.Parent.Parent.Fusion)
local FusionTypes = require(script.Parent.Parent.FusionTypes)
local inOrder = require(script.Parent.Parent.Util.inOrder)
local getter = require(script.Parent.Parent.Util.getter)
local get = require(script.Parent.Parent.Util.get)
local StatLabel = require(script.Parent.StatLabel)

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

export type PlayerStatInfo = {
	Name: string;
	Color: FusionTypes.CanBeState<Color3>?;
	Value: FusionTypes.CanBeState<any>?;
}

export type Props = {
	Name: FusionTypes.CanBeState<string>?;
	DisplayName: FusionTypes.CanBeState<string>?;
	UserId: FusionTypes.CanBeState<number>?;

	Selected: FusionTypes.CanBeState<boolean>?;

	-- Stats: FusionTypes.CanBeState<{[string]: FusionTypes.CanBeState<any>?}>?;
	Stats: FusionTypes.CanBeState<{PlayerStatInfo}>?;

	OnClick: () -> nil;
}

return function(props: Props)
	local Name = getter(props.Name, "[unknown]")
	local DisplayName = getter(props.DisplayName, "[unknown]")
	local UserId = getter(props.UserId, 0)

	local Selected = getter(props.Selected, false)
	local SelectedAlpha = Spring(Computed(function()
		return if (Selected:get()) then 1 else 0
	end), 50, 1)

	local Stats = getter(props.Stats, {})

	local Hovering = Value(false)
	local HoverAlpha = Spring(Computed(function()
		return if (Hovering:get()) then 1 else 0
	end), 50, 1)

	return e("ImageButton"){
		Name = "PlayerEntry";

		Size = Computed(function()
			return UDim2.new(1, 0, 0, get(UISettings.PlayerEntryHeight))
		end);

		BackgroundColor3 = Computed(function()
			return get(UISettings.ThemeColor)
			:Lerp(get(UISettings.PlayerEntryHoverColor), HoverAlpha:get())
			:Lerp(get(UISettings.PlayerEntrySelectedColor), SelectedAlpha:get())
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
		[OnEvent("MouseButton1Down")] = function()
			if (type(props.OnClick) == "function") then
				props.OnClick()
			end
		end;
	
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
			e("UIListLayout"){
				Padding = UDim.new(0,10);
				FillDirection = Enum.FillDirection.Horizontal;
				SortOrder = Enum.SortOrder.LayoutOrder;
			};
			e("Frame"){
				Name = "Stats";

				AutomaticSize = Enum.AutomaticSize.X;
				Size = UDim2.fromScale(0,1);

				BackgroundTransparency = 1;
				BorderSizePixel = 0;

				LayoutOrder = 1;
	
				[Children] = inOrder{
					e("UIListLayout"){
						Padding = UDim.new(0,10);
						FillDirection = Enum.FillDirection.Horizontal;
						SortOrder = Enum.SortOrder.LayoutOrder;
					};
					ForPairs(Stats, function(Index: number, Info: PlayerStatInfo)
						local StatName: string = get(Info.Name)
						local Value: any = get(Info.Value)
						local HasValue: boolean = (Value ~= nil)

						return StatName, StatLabel{
							Width = Global.HeaderStatWidths[StatName];

							props = {
								Name = Name;
								Text = if (HasValue) then tostring(Value) else "-";
								TextColor3 = if (HasValue) then get(Info.Color) else get(UISettings.UnknownStatTextColor);

								LayoutOrder = Index;
							};
						}
					end, Fusion.cleanup);
				};
			};
			e("Frame"){
				Name = "Player";

				Size = UDim2.fromScale(0,1);

				BackgroundTransparency = 1;
				BorderSizePixel = 0;
	
				[Children] = {
					e("UIListLayout"){
						Padding = UDim.new(0,10);
						FillDirection = Enum.FillDirection.Horizontal;
						SortOrder = Enum.SortOrder.LayoutOrder;
						VerticalAlignment = Enum.VerticalAlignment.Center;
					};
					e("UIFlexItem"){
						FlexMode = Enum.UIFlexMode.Fill;
					};
					Computed(function()
						if not (get(UISettings.ShowUserThumbnails)) then return end

						return e("ImageLabel"){
							Name = "Thumbnail";
	
							Size = Computed(function()
								return UDim2.fromOffset(get(UISettings.PlayerEntryThumbnailSize), get(UISettings.PlayerEntryThumbnailSize))
							end);
	
							BackgroundColor3 = Color3.fromRGB(0,0,0);
							BackgroundTransparency = .75;
							BorderSizePixel = 0;
	
							Image = Computed(function()
								return getPlayerThumbnail(UserId:get())
							end);
		
							[Children] = {
								-- e("UIAspectRatioConstraint"){};
								e("UICorner"){
									CornerRadius = UDim.new(1,0);
								};
							};
						};
					end, Fusion.cleanup);
					e("TextLabel"){
						Name = "DisplayName";

						Size = UDim2.fromScale(1,1);
						
						BackgroundTransparency = 1;
						BorderSizePixel = 0;

						Text = DisplayName;
						TextColor3 = UISettings.TextColor;
						TextSize = 14;
						TextXAlignment = Enum.TextXAlignment.Left;
						FontFace = Computed(function()
							return Font.new(
								get(UISettings.FontFamily),
								Enum.FontWeight.SemiBold,
								Enum.FontStyle.Normal
							)
						end);

						LayoutOrder = 1;
	
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
				};
			};
		};
	}
end