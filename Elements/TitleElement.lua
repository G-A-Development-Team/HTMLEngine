TitleElement = setmetatable({}, { __index = Element })
TitleElement.__index = TitleElement


function TitleElement.new(element)
    local o = Element.new(element)
    o.Type = "Title"
    o = o or {}
    setmetatable(o, TitleElement)

    return o
end