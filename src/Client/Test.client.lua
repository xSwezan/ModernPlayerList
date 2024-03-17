local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MPL = require(ReplicatedStorage.lib.lib)
MPL:Load()

MPL:AddAction("View", {
	Text = "View";
	Icon = "rbxassetid://16756274878";
	Color = Color3.fromRGB(255, 255, 255);
}, function(Player: Player)
	print("View", Player.Name)
	game.GuiService:InspectPlayerFromUserId(Player.UserId)
end)

MPL:AddAction("Kick", {
	Text = "Kick";
	Icon = "rbxassetid://16756264561";
	Color = Color3.fromRGB(255, 0, 0);
}, function(Player: Player)
	print("Kick", Player.Name)
end)

MPL:AddAction("Report", {
	Text = "Report";
	Icon = "rbxassetid://16756258506";
	Color = Color3.fromRGB(255, 0, 0);
}, function(Player: Player)
	print("Report", Player.Name)
end)