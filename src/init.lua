local defaultProps = require(script.defaultProps)

local children = "__children__"

local function event(eventName: string): string
	return "__event_" .. eventName .. "__"
end

local function capitalize(str: string): string
	local split = string.split(str, "")
	local table_ = table.create(#split)
	for index, value in split do
		table_[index] = index == 1 and string.upper(value) or value
	end
	return table.concat(table_, "")
end

local function applyProperties(instance: Instance, properties: { [string]: any}?): Instance
	if not properties then
		properties = {}
	end

	local cleanupTasks = {}

	for key, value in properties do
		if key == children then
			if type(key) == "table" then
				for _, child in value do
					assert(typeof(child) == "Instance", "Child must be an instance")
					child.Parent = instance
				end
			elseif typeof(value) == "Instance" then
				value.Parent = instance
			end
		elseif string.match(key, "__event_") then
			local eventName = string.split(key, "_")[4]
			assert(eventName, "Invalid event name")
			assert(type(value) == "function", "Event must be a function")

			local event_: RBXScriptSignal | nil = instance[capitalize(eventName)]
			assert(event_, "Event does not exist for ClassName " .. instance.ClassName)

			local connection = event_:Connect(value)
			table.insert(cleanupTasks, function()
				connection:Disconnect()
			end)
		elseif key ~= "parent" then
			instance[capitalize(key)] = value
		end
	end

	if properties.parent then
		instance.Parent = properties.parent
	end

	local mad = instance.Destroying:Connect(function()
		for _, task in cleanupTasks do
			task()
		end

		for _, descendant in instance:GetDescendants() do
			descendant:Destroy()
		end
	end)

	table.insert(cleanupTasks, function()
		mad:Disconnect()
	end)

	return instance
end

local function clone(instance: Instance, properties: { [string]: any }): Instance
	assert(typeof(instance) == "Instance", "Instance must be an instance")
	local newInstance = instance:Clone()

	if properties and not properties.parent then
		properties.parent = instance.Parent
	end

	applyProperties(newInstance, properties)
	return newInstance
end

local function create(className: string, properties: { [string]: any }): Instance
	local success, instance = pcall(Instance.new, Instance, className)
	if not success then
		error("Invalid ClassName: " .. className)
	end

	if defaultProps[className] then
		for key, value in defaultProps[className] do
			instance[key] = value
		end
	end

	applyProperties(instance, properties)
	return instance
end

return {
	event = event,
	clone = clone,
	create = create,
	children = children,
	default = create
}
