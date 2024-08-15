-- Element.lua

-- Define the Element class
Element = {}
Element.__index = Element

-- Constructor for new instances
function Element.new(HTMLElement)
    local o = {}  -- create a new table if the user doesn't provide one
    setmetatable(o, Element)
    -- Initialize default values
    o.Content = nil
    o.X = 0
    o.Y = 0
    o.W = 0
    o.H = 0
    o.Padding = {
        Left = 0,
        Right = 0,
        Top = 0,
        Bottom = 0,
    }
    o.HTMLElement = HTMLElement
    return o
end

function Element:SetHTMLElement(element)
    self.HTMLElement = element
end

function Element:GetHTMLElement()
    return self.HTMLElement
end

-- Method to set content
function Element:SetContent(content)
    self.Content = content
end

-- Method to get content
function Element:GetContent()
    return self.Content
end