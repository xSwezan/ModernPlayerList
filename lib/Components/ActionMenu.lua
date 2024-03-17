local EngineAPICloudProcessingService = game:GetService("EngineAPICloudProcessingService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local FusionTypes = require(ReplicatedStorage.lib.lib.FusionTypes)
local UISettings = require(script.Parent.Parent.UISettings)
local getPlayerThumbnail = require(script.Parent.Parent.Util.getPlayerThumbnail)
local Fusion = require(script.Parent.Parent.Parent.Fusion)
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
	Player: FusionTypes.CanBeState<Player?>?;
	ActionButtons: FusionTypes.CanBeState<{Instance}>?;

	props: {[any]: FusionTypes.CanBeState<any>}?;
	CanvasGroupProps: {[any]: FusionTypes.CanBeState<any>}?;
}

return function(props: Props)
	local Player: FusionTypes.StateObject<Player?> = getter(props.Player, nil)

	local AbsoluteContentSize = Value(Vector2.zero)
	local ContentHeight = Computed(function()
		return (AbsoluteContentSize:get() or Vector2.zero).Y
	end)

	local ScrollBarVisible = Computed(function()
		return (get(UISettings.PlayerContainerMaxHeight) < ContentHeight:get())
	end)

	return Hydrate(e("CanvasGroup"){
		Name = "ActionMenu";

		AutomaticSize = Enum.AutomaticSize.Y;
		Size = Computed(function()
			return UDim2.fromOffset(get(UISettings.ActionMenuWidth), 0)
		end);

		Position = UDim2.fromScale(.5,.5);
		AnchorPoint = Vector2.new(1,0);

		BackgroundTransparency = 1;

		ClipsDescendants = true;

		[Children] = {
			e("UICorner"){
				CornerRadius = Computed(function()
					return UDim.new(0, get(UISettings.CornerRadius))
				end);
			};
			Hydrate(e("CanvasGroup"){
				AutomaticSize = Enum.AutomaticSize.Y;
				Size = UDim2.fromScale(1,0);
		
				Position = UDim2.fromScale(0,0);
				AnchorPoint = Vector2.new(0,0);
		
				BackgroundTransparency = 1;
				BorderSizePixel = 0;
			
				[Children] = {
					e("UICorner"){
						CornerRadius = Computed(function()
							return UDim.new(0, get(UISettings.CornerRadius))
						end);
					};
					e("UIListLayout"){
						Padding = Computed(function()
							return UDim.new(0, get(UISettings.Spacing))
						end);
						SortOrder = Enum.SortOrder.LayoutOrder;
					};
					e("Frame"){
						Name = "Header";
		
						AutomaticSize = Enum.AutomaticSize.X;
						Size = Computed(function()
							return UDim2.new(1, 0, 0, get(UISettings.ActionMenuHeaderHeight))
						end);
						
						BackgroundColor3 = Color3.fromRGB(0,0,0);
						BackgroundTransparency = .1;
						BorderSizePixel = 0;
			
						[Children] = {
							e("UIListLayout"){
								Padding = UDim.new(0,10);
								FillDirection = Enum.FillDirection.Horizontal;
								SortOrder = Enum.SortOrder.LayoutOrder;
								VerticalAlignment = Enum.VerticalAlignment.Center;
							};
							Computed(function()
								return e("UIPadding"){
									PaddingBottom = UDim.new(0, get(UISettings.Padding));
									PaddingLeft = UDim.new(0, get(UISettings.Padding));
									PaddingRight = UDim.new(0, get(UISettings.Padding));
									PaddingTop = UDim.new(0, get(UISettings.Padding));
								}
							end, Fusion.cleanup);
							e("Frame"){
								Name = "Name";
		
								AutomaticSize = Enum.AutomaticSize.XY;
		
								BackgroundTransparency = 1;
								BorderSizePixel = 0;
		
								LayoutOrder = 1;
			
								[Children] = {
									e("TextLabel"){
										Name = "DisplayName";
		
										AutomaticSize = Enum.AutomaticSize.XY;
		
										Text = Computed(function()
											local Player = Player:get()
											if not (Player) then
												return "???"
											end

											return Player.DisplayName
										end);
										TextColor3 = Color3.fromRGB(255,255,255);
										TextSize = 14;
										TextXAlignment = Enum.TextXAlignment.Left;
										FontFace = Font.new(
											get(UISettings.FontFamily),
											Enum.FontWeight.SemiBold,
											Enum.FontStyle.Normal
										);
		
										BackgroundTransparency = 1;
										BorderSizePixel = 0;
		
										LayoutOrder = 1;
									};
									e("TextLabel"){
										Name = "PlayerName";
		
										AutomaticSize = Enum.AutomaticSize.XY;
		
										Text = Computed(function()
											local Player = Player:get()
											if not (Player) then
												return "???"
											end

											return `@{Player.Name}`
										end);
										TextColor3 = Color3.fromRGB(100,100,100);
										TextSize = 10;
										TextXAlignment = Enum.TextXAlignment.Left;
										FontFace = Computed(function()
											return Font.new(
												get(UISettings.FontFamily),
												Enum.FontWeight.SemiBold,
												Enum.FontStyle.Normal
											)
										end);
										
										BackgroundTransparency = 1;
										BorderSizePixel = 0;
										LayoutOrder = 1;
									};
									e("UIListLayout"){
										SortOrder = Enum.SortOrder.LayoutOrder;
									};
								};
							};
							e("ImageLabel"){
								Name = "Thumbnail";
		
								Size = UDim2.fromScale(1,1);
		
								Image = Computed(function()
									local Player = Player:get()
									if not (Player) then
										return "rbxassetid://0"
									end

									return getPlayerThumbnail(Player.UserId)
								end);
								BackgroundColor3 = Color3.fromRGB(0,0,0);
								BackgroundTransparency = .5;
								BorderSizePixel = 0;
			
								[Children] = {
									e("UIAspectRatioConstraint"){};
									e("UICorner"){
										CornerRadius = UDim.new(1,0);
									};
								};
							};
						};
					};
					e("ScrollingFrame"){
						Name = "List";
		
						Size = Computed(function()
							return UDim2.new(1, 0, 0, ContentHeight:get())
						end);
						
						BackgroundTransparency = 1;
						BorderSizePixel = 0;
		
						ScrollBarImageColor3 = UISettings.ThemeColor;
						ScrollBarImageTransparency = .75;
						ScrollBarThickness = UISettings.ScrollBarThickness;
						ScrollingDirection = Enum.ScrollingDirection.Y;
						VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar;
						
						AutomaticCanvasSize = Enum.AutomaticSize.Y;
						CanvasSize = Computed(function()
							return UDim2.fromOffset(0, ContentHeight:get())
						end);
						
						BottomImage = "rbxassetid://16756172235";
						MidImage = "rbxassetid://16756172235";
						TopImage = "rbxassetid://16756172235";
						
						LayoutOrder = 1;
						Active = true;
			
						[Children] = {
							e("UIListLayout"){
								Padding = Computed(function()
									return UDim.new(0, get(UISettings.Spacing))
								end);
								SortOrder = Enum.SortOrder.LayoutOrder;
		
								[Out("AbsoluteContentSize")] = AbsoluteContentSize;
							};
							e("UISizeConstraint"){
								MaxSize = Computed(function()
									return Vector2.new(math.huge, get(UISettings.ActionMenuMaxHeight))
								end);
							};
							e("UIPadding"){
								PaddingRight = Computed(function()
									return UDim.new(0, if (ScrollBarVisible:get()) then get(UISettings.ScrollBarExtraPadding) else 0)
								end);
							};
							props.ActionButtons;
						};
					};
				};
			})(props.CanvasGroupProps or {})
		}
	})(props.props or {})
end