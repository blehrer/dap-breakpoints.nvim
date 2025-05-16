local MenuItem = {}
MenuItem.__index = MenuItem
MenuItem.__tostring = function(self)
  return self.key and self.bp and ("%s: %s"):format(self.key, self:get()) or nil
end

---@class MenuItem
---@field key string
---@field bp DapBp.Breakpoint
---@field menu_key fun(MenuItem): string
---@field new fun(table): MenuItem
---@field get fun (MenuItem): string
---@field set fun(MenuItem, string): nil

---@param o any
---@return MenuItem
function MenuItem.new(o)
  local self = setmetatable({}, MenuItem)
  self.__index = self
  self.bp = o.bp
  self.key = o.key
  return self
end

---@type DapBp.Breakpoint?
MenuItem.bp = nil

---@type string?
MenuItem.key = nil

---@param self MenuItem
---@return string
---@type function(MenuItem): string
function MenuItem.menu_key(self)
  -- from http://lua-users.org/wiki/StringRecipes#:~:text=Change%20an%20entire,w_%27%5D*)%22%2C%20tchelper)
  ---@param first string
  ---@param rest string
  ---@return string
  local function to_title_case(first, rest)
    return first:upper() .. rest:lower()
  end
  local str = self.key
  if str:find("[a-z][A-Z]") then
    str = str:gsub("([a-z])([A-Z])", "%1 %2")
  end
  str = str:gsub("(%a)([%w_']*)", to_title_case)
  return str
end

---@param self MenuItem
---@return string
function MenuItem.get(self)
  return self.bp[self.key]
end

---@type function(MenuItem, string)
---@param self MenuItem
---@param value string
function MenuItem.set(self, value)
  self.bp[self.key] = value
end

return MenuItem
