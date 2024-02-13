local M = {}

local outline = require("outline")
function M.setup()
  outline.setup {
    outline_window = {
       show_numbers = true,
    },
    symbols = {
      icons = {
      File = { icon = "", hl = "Identifier" },
      Module = { icon = "", hl = "Include" },
      Namespace = { icon = "", hl = "Include" },
      Package = { icon = "", hl = "Include" },
      Class = { icon = "", hl = "Type" },
      Method = { icon = "ƒ", hl = "Function" },
      Property = { icon = "", hl = "Identifier" },
      Field = { icon = "", hl = "Identifier" },
      Constructor = { icon = "", hl = "Special" },
      Enum = { icon = "", hl = "Type" },
      Interface = { icon = "", hl = "Type" },
      Function = { icon = "", hl = "Function" },
      Variable = { icon = "", hl = "Constant" },
      Constant = { icon = "", hl = "Constant" },
      String = { icon = "", hl = "String" },
      Number = { icon = "", hl = "Number" },
      Boolean = { icon = "", hl = "Boolean" },
      Array = { icon = "󰅪", hl = "Constant" },
      Object = { icon = "⦿", hl = "Type" },
      Key = { icon = "", hl = "Type" },
      Null = { icon = "NULL", hl = "Type" },
      EnumMember = { icon = "", hl = "Identifier" },
      Struct = { icon = "", hl = "Structure" },
      Event = { icon = "", hl = "Type" },
      Operator = { icon = "", hl = "Identifier" },
      TypeParameter = { icon = "𝙏", hl = "Identifier" },
      Component = { icon = "󰅴", hl = "Function" },
      Fragment = { icon = "󰅴", hl = "Constant" },
      TypeAlias = { icon = " ", hl = "Type" },
      Parameter = { icon = " ", hl = "Identifier" },
      StaticMethod = { icon = " ", hl = "Function" },
      Macro = { icon = " ", hl = "Function" },
    },
    }
  }
end

return M
