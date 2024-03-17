local Global = require(script.Parent.Parent.Global)
local UISettings = require(script.Parent.Parent.UISettings)
local Fusion = require(script.Parent.Parent.Parent.Fusion)
local FusionTypes = require(script.Parent.Parent.FusionTypes)
local inOrder = require(script.Parent.Parent.Util.inOrder)
local getter = require(script.Parent.Parent.Util.getter)
local get = require(script.Parent.Parent.Util.get)
local StatCategory = require(script.Parent.StatCategory)

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

export type StatCategoryInfo = {
	Name: FusionTypes.CanBeState<string>?;
	DisplayName: FusionTypes.CanBeState<string>?;
	Color: FusionTypes.CanBeState<Color3>?;
}

export type Props = {
	ScrollBarThickness: FusionTypes.CanBeState<number>?;

	-- StatCategories: FusionTypes.CanBeState<{[string]: FusionTypes.CanBeState<Color3>?;}>?;
	StatCategories: FusionTypes.CanBeState<{StatCategoryInfo}>?;

	props: FusionTypes.CanBeState<{[any]: FusionTypes.CanBeState<any>}>?;
}

return function(props: Props)
	local ScrollBarThickness = getter(props.ScrollBarThickness, 0)
	local StatCategories = getter(props.StatCategories, {})

	return Hydrate(e("ImageButton"){
		Name = "Header";

		AutomaticSize = Enum.AutomaticSize.X;
		Size = Computed(function()
			return UDim2.new(1, 0, 0, get(UISettings.HeaderHeight))
		end);

		BackgroundColor3 = UISettings.ThemeColor;
		BackgroundTransparency = UISettings.HeaderBackgroundTransparency;
		BorderSizePixel = 0;

		Image = "";

		[Children] = {
			e("UIListLayout"){
				Padding = Computed(function()
					return UDim.new(0, get(UISettings.Padding))
				end);
				FillDirection = Enum.FillDirection.Horizontal;
				SortOrder = Enum.SortOrder.LayoutOrder;
			};
			Computed(function()
				return e("UIPadding"){
					PaddingBottom = UDim.new(0, get(UISettings.PlayerEntryInnerPadding));
					PaddingLeft = UDim.new(0, get(UISettings.PlayerEntryInnerPadding));
					PaddingRight = UDim.new(0, get(UISettings.PlayerEntryInnerPadding) + ScrollBarThickness:get());
					PaddingTop = UDim.new(0, get(UISettings.PlayerEntryInnerPadding));
				}
			end, Fusion.cleanup);
			e("TextLabel"){
				Name = "Category";

				-- Size = UDim2.new(0,100,1,0);
				Size = Computed(function()
					return UDim2.new(0, get(UISettings.Width) - get(UISettings.Padding) * 2, 1, 0)
				end);
				
				BackgroundTransparency = 1;
				BorderSizePixel = 0;
				
				FontFace = Computed(function()
					return Font.new(
						get(UISettings.FontFamily),
						Enum.FontWeight.SemiBold,
						Enum.FontStyle.Normal
					)
				end);
				Text = "Player";
				TextColor3 = UISettings.HeaderTextColor;
				TextSize = 12;
				TextXAlignment = Enum.TextXAlignment.Left;

				LayoutOrder = 0;

				[Children] = {
					e("UIGradient"){
						Transparency = NumberSequence.new{
							NumberSequenceKeypoint.new(0,0);
							NumberSequenceKeypoint.new(.9,0);
							NumberSequenceKeypoint.new(1,1);
						};
					};
				};
			};
			ForPairs(StatCategories, function(Index: number, Info: StatCategoryInfo)
				local Width = Value(Vector2.zero)

				local Label: TextLabel = StatCategory{
					Text = Info.DisplayName or Info.Name;
					Color = Info.Color;

					props = {
						LayoutOrder = Index;
					};
				}

				Width:set(Label.AbsoluteSize)

				Hydrate(Label){
					[Cleanup] = {
						Label:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
							Width:set(Label.AbsoluteSize)
						end);
					}
				}

				Global.HeaderStatWidths[get(Info.Name)] = Computed(function()
					return math.max(get(UISettings.MinStatWidth), (Width:get() or Vector2.zero).X)
				end)

				return Index, Label
			end, Fusion.cleanup);
		};
	})(props.props or {})
end