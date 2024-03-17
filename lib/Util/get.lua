return function(Value: any): any
	if (type(Value) == "table") and (type(Value.get) == "function") then
		return Value:get()
	end

	return Value
end