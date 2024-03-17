local Fusion = require(script.Parent.Parent.Fusion)
local FusionTypes = require(script.Parent.FusionTypes)

local Value = Fusion.Value

export type Settings = {
	ThemeColor: FusionTypes.CanBeState<Color3>?;
	TextColor: FusionTypes.CanBeState<Color3>?;
	HeaderTextColor: FusionTypes.CanBeState<Color3>?;
	UnknownStatTextColor: FusionTypes.CanBeState<Color3>?;

	CornerRadius: FusionTypes.CanBeState<number>?;
	Spacing: FusionTypes.CanBeState<number>?;
	Padding: FusionTypes.CanBeState<number>?;
	Offset: FusionTypes.CanBeState<UDim2>?;
	ScrollBarThickness: FusionTypes.CanBeState<number>?;
	ScrollBarExtraPadding: FusionTypes.CanBeState<number>?;

	FontFamily: FusionTypes.CanBeState<string>?;

	PlayerContainerMaxHeight: FusionTypes.CanBeState<number>?;
	Width: FusionTypes.CanBeState<number>?;

	HeaderHeight: FusionTypes.CanBeState<number>?;
	HeaderBackgroundTransparency: FusionTypes.CanBeState<number>?;
	UseHeaderTextColorForStatCategory: FusionTypes.CanBeState<boolean>?;

	ActionMenuWidth: FusionTypes.CanBeState<number>?;
	ActionMenuHeaderHeight: FusionTypes.CanBeState<number>?;
	ActionMenuMaxHeight: FusionTypes.CanBeState<number>?;
	ActionMenuOffset: FusionTypes.CanBeState<UDim2>?;

	PlayerEntryHeight: FusionTypes.CanBeState<number>?;
	PlayerEntryInnerPadding: FusionTypes.CanBeState<number>?;
	PlayerEntryThumbnailSize: FusionTypes.CanBeState<number>?;
	PlayerEntryBackgroundTransparency: FusionTypes.CanBeState<number>?;
	PlayerEntryHoverColor: FusionTypes.CanBeState<Color3>?;
	PlayerEntrySelectedColor: FusionTypes.CanBeState<Color3>?;
	ShowUserThumbnails: FusionTypes.CanBeState<boolean>?;

	ActionButtonHeight: FusionTypes.CanBeState<number>?;
	ActionButtonInnerPadding: FusionTypes.CanBeState<number>?;
	ActionButtonIconSize: FusionTypes.CanBeState<number>?;
	ActionButtonHoverColor: FusionTypes.CanBeState<Color3>?;

	ContextMenuInnerPadding: FusionTypes.CanBeState<number>?;

	ContextActionHeight: FusionTypes.CanBeState<number>?;
	ContextActionBackgroundTransparency: FusionTypes.CanBeState<number>?;

	MinStatWidth: FusionTypes.CanBeState<number>?;
	StatInnerPadding: FusionTypes.CanBeState<number>?;
}

local DefaultSettings: Settings = {
	ThemeColor = Value(Color3.fromRGB(0,0,0));
	TextColor = Value(Color3.fromRGB(255,255,255));
	HeaderTextColor = Value(Color3.fromRGB(100,100,100));
	UnknownStatTextColor = Value(Color3.fromRGB(100,100,100));
	
	CornerRadius = Value(8);
	Spacing = Value(1);
	Padding = Value(10);
	Offset = Value(UDim2.fromOffset(-10, 10));
	ScrollBarThickness = Value(5);
	ScrollBarExtraPadding = Value(0);
	
	FontFamily = Value("rbxassetid://12187365364"); -- Inter
	
	PlayerContainerMaxHeight = Value(300);
	Width = Value(200);

	HeaderHeight = Value(30);
	HeaderBackgroundTransparency = Value(.1);
	UseHeaderTextColorForStatCategory = Value(false);

	ActionMenuWidth = Value(150);
	ActionMenuHeaderHeight = Value(60);
	ActionMenuMaxHeight = Value(150);
	ActionMenuOffset = Value(UDim2.fromOffset(-10, 0));

	PlayerEntryHeight = Value(40);
	PlayerEntryInnerPadding = Value(10);
	PlayerEntryThumbnailSize = Value(25);
	PlayerEntryBackgroundTransparency = Value(.4);
	PlayerEntryHoverColor = Value(Color3.fromRGB(30,30,30));
	PlayerEntrySelectedColor = Value(Color3.fromRGB(60,60,60));
	ShowUserThumbnails = Value(true);

	ActionButtonHeight = Value(40);
	ActionButtonInnerPadding = Value(10);
	ActionButtonIconSize = Value(25);
	ActionButtonHoverColor = Value(Color3.fromRGB(30,30,30));

	ContextMenuInnerPadding = Value(10);

	ContextActionHeight = Value(25);
	ContextActionBackgroundTransparency = Value(.1);

	MinStatWidth = Value(50);
	StatInnerPadding = Value(5);
}

return DefaultSettings