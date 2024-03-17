return function(Parent: Instance, Name: string, IsA: string?, Recursive: boolean?): Instance?
	local ToLoop: {Instance} = if (Recursive) then Parent:GetDescendants() else Parent:GetChildren()

	for _, Object: Instance in ToLoop do
		if (Object.Name ~= Name) then continue end
		if (IsA) and not (Object:IsA(IsA)) then continue end

		return Object
	end

	return
end