local ok, config = pcall(require, "config")

if not ok then
	return {}
end

return config
