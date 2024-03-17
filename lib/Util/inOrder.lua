local Fusion = require(script.Parent.Parent.Parent.Fusion)

return function(Children: {GuiObject}, Start: number?)
	local Index: number = Start or 0

	for _, Child: GuiObject in ipairs(Children) do
		local Ok: boolean = pcall(function()
			return Child.LayoutOrder
		end)

		if not (Ok) then continue end

		Index += 1

		pcall(function()
			Child.LayoutOrder = Index

			Fusion.Hydrate(Child){
				LayoutOrder = Index;
			}
		end)
	end

	return Children
end