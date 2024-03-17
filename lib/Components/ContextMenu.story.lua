local Fusion = require(script.Parent.Parent.Parent.Fusion)
local ToggleContextAction = require(script.Parent.ContextActions.ToggleContextAction)

return function(target)
	local Toggled = Fusion.Value(false)

	local App = require(script.Parent.ContextMenu){
		props = {
			[Fusion.Children] = {
				ToggleContextAction{
					Toggled = Toggled;
					TextProps = {
						Text = "Hello";
						TextColor3 = Color3.fromRGB(0,255,0);
					};
				};
				ToggleContextAction{
					Toggled = Toggled;
					TextProps = {
						Text = "Hello Again";
						TextColor3 = Color3.fromRGB(255,0,0);
					};
				};
				ToggleContextAction{
					Toggled = Toggled;
					TextProps = {
						Text = "Hello Again Again";
						TextColor3 = Color3.fromRGB(0,0,255);
					};
				};
			}
		};
	}
	App.Parent = target

	return function()
		App:Destroy()
	end
end