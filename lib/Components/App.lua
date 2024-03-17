local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local statValueUtil = require(script.Parent.Parent.Util.statValueUtil)
local FusionTypes = require(script.Parent.Parent.FusionTypes)
local UISettings = require(script.Parent.Parent.UISettings)
local Global = require(script.Parent.Parent.Global)
local TableUtil = require(script.Parent.Parent.Parent.TableUtil)
local findFirst = require(script.Parent.Parent.Util.findFirst)
local Fusion = require(script.Parent.Parent.Parent.Fusion)
local get = require(script.Parent.Parent.Util.get)
local getter = require(script.Parent.Parent.Util.getter)
local recordAttribute = require(script.Parent.Parent.Util.recordAttribute)
local ActionMenu = require(script.Parent.ActionMenu)
local PlayerEntry = require(script.Parent.PlayerEntry)
local ActionButton = require(script.Parent.ActionButton)
local ContextMenu = require(script.Parent.ContextMenu)
local ToggleContextAction = require(script.Parent.ContextActions.ToggleContextAction)

local LocalPlayer: Player = Players.LocalPlayer
local Mouse: Mouse = LocalPlayer:GetMouse()

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

export type StatInfo = {
	Name: string;
	DisplayName: string;
	Color: FusionTypes.Value<Color3>;
	Toggled: FusionTypes.Value<boolean>;
	Object: ValueBase;
}

export type Props = {
	FakePlayers: {Player}?;
}

return function(props: Props)
	local AbsoluteContentSize = Value(Vector2.zero)
	local ContentHeight = Computed(function()
		return (AbsoluteContentSize:get() or Vector2.zero).Y
	end)

	local ScrollBarVisible = Computed(function()
		return (get(UISettings.PlayerContainerMaxHeight) < ContentHeight:get())
	end)

	local RawPlayerListAbsolutePosition = Value(Vector2.new())
	local PlayerListAbsolutePosition = getter(RawPlayerListAbsolutePosition, Vector2.zero)
	local PlayerListToggled = Value(true)
	local PlayerListAlpha = Spring(Computed(function()
		return if (PlayerListToggled:get()) then 1 else 0
	end), 25, 1)

	local ActionMenuVisible = Value(false)
	local ActionMenuRelativePosition = Value(UDim2.new())
	local ActionMenuAlpha = Spring(Computed(function()
		return if (ActionMenuVisible:get()) then 1 else 0
	end), 25, 1)

	local SelectedPlayer = Value(nil)
	local ActionMenuPlayer = Value(nil)

	local StatContextMenuVisible = Value(false)
	local StatContextMenuAlpha = Spring(Computed(function()
		return if (StatContextMenuVisible:get()) then 1 else 0
	end), 25, 1)

	local CleanupTable: {any} = {}

	local PlayersInGame = Value(TableUtil.Extend(Players:GetPlayers(), props.FakePlayers or {}))
	local PlayersToShow = ForValues(PlayersInGame, function(Player: Player)
		return Player
	end, Fusion.doNothing)
	local PlayersToShowWithLocalPlayerFirst = Computed(function()
		local PlayerTable = PlayersToShow:get()

		table.sort(PlayerTable, function(a, b)
			return (a == Players.LocalPlayer)
		end)

		return PlayerTable
	end)

	local function GetStatValue(ForStat: string): ValueBase?
		for _, Player: Player in ipairs(PlayersToShowWithLocalPlayerFirst:get()) do
			local leaderstats: Folder? = Player:FindFirstChild("leaderstats") :: Folder?
			if not (leaderstats) then continue end

			local StatValue: ValueBase? = findFirst(leaderstats, ForStat, "ValueBase") :: ValueBase?
			if not (StatValue) then continue end

			return StatValue
		end

		return
	end

	local function GetStatValues(): {[Player]: {StatInfo}}
		local Output = {}

		for _, Player: Player in ipairs(PlayersToShow:get()) do
			Output[Player] = {}

			local leaderstats: Folder? = Player:FindFirstChild("leaderstats") :: Folder?
			if not (leaderstats) then continue end

			local Values = {}

			for _, StatValue: Instance in ipairs(leaderstats:GetChildren()) do
				if not (StatValue:IsA("ValueBase")) then continue end

				local NewStat: StatInfo = {
					Name = StatValue.Name;
					DisplayName = StatValue:GetAttribute("DisplayName") or StatValue.Name;
					Object = StatValue;
					Toggled = Value(true);
					Color = statValueUtil.getColorState(StatValue);
				}

				table.insert(Values, NewStat)
			end

			table.sort(Values, function(a, b)
				return (a.Name < b.Name)
			end)

			Output[Player] = Values
		end

		return Output
	end

	local function GetStatNames()
		local StatNames: {string} = {}

		for _, Player: Player in PlayersToShow:get() do
			local leaderstats: Folder? = Player:FindFirstChild("leaderstats") :: Folder?
			if not (leaderstats) then continue end

			for _, StatValue: Instance in ipairs(leaderstats:GetChildren()) do
				if not (StatValue:IsA("ValueBase")) then continue end
				if (table.find(StatNames, StatValue.Name)) then continue end

				table.insert(StatNames, StatValue.Name)
			end
		end

		table.sort(StatNames)

		return StatNames
	end

	local RawStatValues: FusionTypes.Value<{[Player]: {StatInfo}}> = Value(GetStatValues())
	local StatValues: FusionTypes.ForPairs<Player, FusionTypes.ForPairs<string, StatInfo>> = ForPairs(PlayersToShow, function(_, Player: Player)
		local TheseStatValues: FusionTypes.StateObject<{StatInfo}> = Computed(function()
			return (RawStatValues:get()[Player] or {})
		end)

		return Player, ForPairs(TheseStatValues, function(_, Stat: StatInfo)
			return Stat.Name, Stat
		end)
	end, Fusion.doNothing)

	local RawStatsToShow: FusionTypes.Value<{string}> = Value(GetStatNames())
	local StatsToShow: FusionTypes.ForValues<number, StatInfo> = ForValues(RawStatsToShow, function(StatName: string)
		local StatValue: ValueBase? = GetStatValue(StatName)
		if not (StatValue) then
			return {
				Name = StatName;
				DisplayName = StatName;
				Color = Color3.fromRGB(255,255,255);
				Object = nil;
			}
		end

		local Stat: StatInfo = {
			Name = StatName;
			DisplayName = getter(recordAttribute(StatValue, "DisplayName"), StatName);
			Color = statValueUtil.getColorState(StatValue);
			Toggled = Value(true);
			Object = nil;
		}

		return Stat
	end, Fusion.doNothing)

	local StatContextMenu: Frame = ContextMenu{
		OnClickOutside = function()
			-- print("rr")
			-- StatContextMenuVisible:set(false)
		end;

		props = {
			Position = UDim2.fromScale(.5,.5);

			GroupTransparency = Computed(function()
				return (1 - StatContextMenuAlpha:get())
			end);

			Visible = Computed(function()
				return (StatContextMenuAlpha:get() > .05)
			end);

			[Children] = ForPairs(StatsToShow, function(Index: number, Stat: StatInfo)
				return Index, ToggleContextAction{
					Toggled = Stat.Toggled;

					props = {
						LayoutOrder = Index;
					};
					TextProps = {
						Text = Stat.Name;
						TextColor3 = Stat.Color;
					};
				};
			end, Fusion.cleanup);
		};
	}

	return e("ScreenGui"){
		Name = "ModernPlayerList";
		ResetOnSpawn = false;
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling;

		[Cleanup] = {
			CleanupTable;
			Players.PlayerAdded:Connect(function()
				PlayersInGame:set(TableUtil.Extend(Players:GetPlayers(), props.FakePlayers or {}))
			end);
			Players.PlayerRemoving:Connect(function()
				PlayersInGame:set(TableUtil.Extend(Players:GetPlayers(), props.FakePlayers or {}))
			end);
			RunService.Heartbeat:Connect(function()
				RawStatValues:set(GetStatValues())
				RawStatsToShow:set(GetStatNames())
			end);
			UserInputService.InputBegan:Connect(function(Input: InputObject, GP: boolean)
				if (GP) then return end
				if (Input.KeyCode == Enum.KeyCode.Tab) then
					PlayerListToggled:set(not PlayerListToggled:get())
				end
			end);
			Observer(PlayerListToggled):onChange(function()
				if not (PlayerListToggled:get()) then
					SelectedPlayer:set(nil)
					ActionMenuVisible:set(false)
				end
			end);
		};
	
		[Children] = {
			StatContextMenu;
			ActionMenu{
				Player = ActionMenuPlayer;

				CanvasGroupProps = {
					GroupTransparency = Computed(function()
						return (1 - ActionMenuAlpha:get())
					end);
					GroupColor3 = Computed(function()
						return Color3.fromRGB(0,0,0):Lerp(Color3.fromRGB(255,255,255), ActionMenuAlpha:get())
					end);
					Position = Computed(function()
						return UDim2.fromScale(1 - ActionMenuAlpha:get(), 0)
					end);
				};
				props = {
					Position = Computed(function()
						return (UDim2.fromOffset(PlayerListAbsolutePosition:get().X, PlayerListAbsolutePosition:get().Y) - ActionMenuRelativePosition:get() + get(UISettings.ActionMenuOffset))
					end);
					-- Size = Computed(function()
					-- 	return UDim2.fromOffset((ActionMenuAlpha:get()) * get(UISettings.ActionMenuWidth), 0)
					-- end);

					Visible = Computed(function()
						return (ActionMenuAlpha:get() > .05)
					end);
				};

				ActionButtons = ForPairs(Global.RegisteredActions, function(Name: string, Action: Global.Action)
					return Name, ActionButton{
						Text = Action.Info.Text;
						Icon = Action.Info.Icon;
						Color = Action.Info.Color;

						OnClick = function()
							if (type(Action.Callback) == "function") then
								local Player: Player? = SelectedPlayer:get()
								if not (Player) then return end
								
								Action.Callback(Player)
							end
						end;

						props = {
							LayoutOrder = table.find(Global.ActionOrder, Name);
						};
					}
				end, Fusion.cleanup);
			};
			e("CanvasGroup"){
				Name = "PlayerList";
				
				AutomaticSize = Enum.AutomaticSize.XY;
				Size = Computed(function()
					return UDim2.fromOffset(get(UISettings.Width), 0)
				end);

				Position = Computed(function()
					return UDim2.new(1, 50, 0, 0):Lerp(UDim2.new(1, 0, 0, 0), PlayerListAlpha:get()) + get(UISettings.Offset)
				end);
				AnchorPoint = Vector2.new(1,0);

				BackgroundTransparency = 1;
				BorderSizePixel = 0;

				GroupTransparency = Computed(function()
					return (1 - PlayerListAlpha:get())
				end);
				GroupColor3 = Computed(function()
					return Color3.fromRGB(0,0,0):Lerp(Color3.fromRGB(255,255,255), PlayerListAlpha:get())
				end);
				Visible = Computed(function()
					return (PlayerListAlpha:get() > .05)
				end);

				[Out("AbsolutePosition")] = RawPlayerListAbsolutePosition;
	
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
					e("UISizeConstraint"){
						MaxSize = Computed(function()
							return Vector2.new(math.huge, get(UISettings.PlayerContainerMaxHeight))
						end);
						MinSize = Computed(function()
							return Vector2.new(0, get(UISettings.HeaderHeight))
						end);
					};
					require(script.Parent.Header){
						ScrollBarThickness = Computed(function()
							return if (ScrollBarVisible:get()) then get(UISettings.ScrollBarThickness) else 0
						end);

						StatCategories = Computed(function()
							local Output = {}
							
							for _, Info: StatInfo in ipairs(StatsToShow:get()) do
								if not (Info.Toggled:get()) then continue end

								table.insert(Output, {
									Name = Info.Name;
									DisplayName = Info.DisplayName;
									Color = if (get(UISettings.UseHeaderTextColorForStatCategory)) then UISettings.HeaderTextColor else Info.Color;
								})
							end

							return Output
						end);

						props = {
							[OnEvent("MouseButton2Down")] = function()
								StatContextMenu.Position = UDim2.fromOffset(Mouse.X + 2, Mouse.Y + 2)
								StatContextMenuVisible:set(true)
							end;
						};
					};
					e("ScrollingFrame"){
						Name = "List";

						Size = Computed(function()
							return UDim2.new(1, 0, 0, ContentHeight:get())
						end);

						AutomaticCanvasSize = Enum.AutomaticSize.Y;
						CanvasSize = Computed(function()
							return UDim2.fromOffset(0, ContentHeight:get())
						end);

						BackgroundTransparency = 1;
						BorderSizePixel = 0;
						
						ScrollBarImageColor3 = UISettings.ThemeColor;
						ScrollBarImageTransparency = .75;
						ScrollBarThickness = UISettings.ScrollBarThickness;
						ScrollingDirection = Enum.ScrollingDirection.Y;
						VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar;
						ScrollingEnabled = Computed(function()
							return not (ActionMenuVisible:get())
						end);

						TopImage = "rbxassetid://16756172235";
						MidImage = "rbxassetid://16756172235";
						BottomImage = "rbxassetid://16756172235";
						
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
									return Vector2.new(math.huge, get(UISettings.PlayerContainerMaxHeight))
								end);
							};
							e("UIPadding"){
								PaddingRight = Computed(function()
									return UDim.new(0, if (ScrollBarVisible:get()) then get(UISettings.ScrollBarExtraPadding) else 0)
								end);
							};
							ForPairs(StatValues, function(Player: Player, Stats: FusionTypes.StateObject<{[string]: StatInfo}>)
								local PlayerStats: FusionTypes.StateObject<{PlayerEntry.PlayerStatInfo}> = Computed(function()
									local PlayerStats: {PlayerEntry.PlayerStatInfo} = {}

									for _, GlobalStat: StatInfo in ipairs(StatsToShow:get()) do
										local Stat: StatInfo = Stats:get()[GlobalStat.Name] or GlobalStat
										if not (GlobalStat.Toggled:get()) then continue end

										if not (Stat.Object) then
											table.insert(PlayerStats, {
												Name = Stat.Name;
												Color = nil;
												Value = nil;
											})
											continue
										end
										
										table.insert(PlayerStats, {
											Name = Stat.Name;
											Color = Stat.Color;
											Value = tostring((Stat.Object :: ValueBase & {Value: any}).Value);
										})
									end

									return PlayerStats
								end)

								local Selected = Computed(function()
									return (SelectedPlayer:get()) and (SelectedPlayer:get().UserId == Player.UserId)
								end)

								local PlayerEntryApp: GuiObject
								PlayerEntryApp = PlayerEntry{
									DisplayName = Player.DisplayName;
									Name = Player.Name;
									UserId = Player.UserId;

									Selected = Selected;

									Stats = PlayerStats;

									OnClick = function()
										if not (PlayerListToggled:get()) then return end

										if (Selected:get()) then
											SelectedPlayer:set(nil)
											ActionMenuVisible:set(false)
										else
											SelectedPlayer:set(Player)
											ActionMenuPlayer:set(Player)

											local AbsolutePosition: Vector2 = PlayerEntryApp.AbsolutePosition
											local RelativePosition: Vector2 = (PlayerListAbsolutePosition:get() - AbsolutePosition)
											ActionMenuRelativePosition:set(UDim2.fromOffset(RelativePosition.X, RelativePosition.Y))
											ActionMenuAlpha:setPosition(0)
											ActionMenuVisible:set(true)
										end
									end;
								}

								return Player.UserId, PlayerEntryApp
							end, Fusion.cleanup);
						};
					};
				};
			};
		};
	}
end