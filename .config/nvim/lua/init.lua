vim.opt.tabstop = 4
vim.opt.shiftwidth = 4

vim.lsp.start({
	name = "lua-language-server",
	cmd = {"bin/lua-language-server"},
	root_dir = vim.fs.dirname(vim.fs.find({'setup.py', 'pyproject.toml'}, { upward = true })[1]),
})

nvim = {}

for k, v in pairs(vim.api) do
	key = k:sub(6)
	nvim[key] = v
end

local classes = {
	"buf",
	"win"
}

classMethods = {}

for i, v in ipairs(classes) do
	
	local methods = {}
	local methodFuncs = {}
	local meta = {
		__index = function(self, key)
			if key == "_wraptype" then
				return v
			end
			print("indexing", v, "wrapper with", key)
			local method = methods[key]
			if type(method) ~= "function" then
				print("no method found, got", type(method), ". Dumping method table:")
				vim.print(methods)
				return nil
			end
			if not methodFuncs[key] then
				methodFuncs[key] = function(self, ...)
					local parseArgs = {}
					for i, v in ipairs({...}) do
						if type(v) == "table" and v._wraptype then
							v = v.v
						end
						parseArgs[i] = v
					end

					return method(self.v, unpack(parseArgs))
				end
			end
		end
	}

	_G[v] = function(handle)
		ret = {
			v = handle,
		}
		setmetatable(ret, meta)
		return ret
	end

	for k, f in pairs(nvim) do
		if k:sub(1, #v+1) == v.."_" then
			methods[k:sub(#v+2)] = f
			print(v, k:sub(#v+2))
		end
	end

	vim.print(methods)

	classMethods[v] = methods
end

require("windows.files")


