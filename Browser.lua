-- Browser.lua

-- Define the Browser class
Browser = {}
Browser.__index = Browser

-- Constructor for new instances
function Browser.new(o)
    o = o or {}  -- create a new table if the user doesn't provide one
    setmetatable(o, Browser)
    -- Initialize default values
    o.Type = "Browser"
    o.X = 300
    o.Y = 300
    o.W = 800
    o.H = 600
    o.MinW = 400
    o.MinH = 300
    o.MaxW = 10000
    o.MaxH = 10000
    o.BoundsHeight = 30
    o.Resize = true
    o.Move = true
    o.OverrideLocation = false
    o.Components = {}
    o.Title = "New Window"
    o.Fonts = {}
    o.TypedElements = {}
    o.BodyHash = 0
    o.ScrollOffset = 0

    return o
end

function Browser:Init()
    self.Fonts["Bahnschrift"] = draw.CreateFont("Bahnschrift", 20, 100)
end

function Browser:Draw(X, Y, W, H)
    --Shadow Background
    Renderer:ShadowRectangle({X, Y}, {W, H}, {0, 0, 0, 255}, 10)


    --Background
    Renderer:FilledRectangle({X, Y}, {W, H}, {255, 255, 255, 255})

    --Titlebar
    Renderer:FilledRectangle({X, Y}, {W, 30}, {46, 46, 46, 255})
    
    --Title
    draw.SetFont(self.Fonts["Bahnschrift"])
    Renderer:TextP({X + 7, Y + 7}, {255, 255, 255, 255}, self.Title)

    --Scissor
    Renderer:Scissor({X, Y + 30}, {W, H - 30})

    local totalContentHeight = 0
    local secElement = getSecondToLastItem(self.TypedElements)

    for _, typedElement in pairs(self.TypedElements) do
        totalContentHeight = totalContentHeight + typedElement.H
    end

    -- Adjust scroll offset if necessary
    local visibleHeight = H - 30
    if totalContentHeight < visibleHeight then
        self.ScrollOffset = 0
    else
        local maxScrollOffset = totalContentHeight - visibleHeight
        if self.ScrollOffset > maxScrollOffset then
            self.ScrollOffset = maxScrollOffset
        end
    end

    for _, typedElement in pairs(self.TypedElements) do
        if typedElement.parent then
            if self.TypedElements[hashTable(typedElement.parent)] then
            end
        else
            if secElement ~= typedElement then
                typedElement:Draw(X, Y + 30 + secElement.H - self.ScrollOffset, W, H - 30)
                Renderer:OutlinedRectangle({typedElement.X, typedElement.Y}, {typedElement.W, typedElement.H}, {255, 0, 0, 255})
            else
                typedElement:Draw(X, Y + 30 - self.ScrollOffset, W, H - 30)
                Renderer:OutlinedRectangle({typedElement.X, typedElement.Y}, {typedElement.W, typedElement.H}, {255, 0, 0, 255})
            end
        end
    end

    --Working Area
    Renderer:OutlinedRectangle({X, Y + 30}, {W, H - 30}, {0, 0, 0, 255})

    local w,h = draw.GetScreenSize()
    Renderer:Scissor({0, 0}, {w, h})

    self:Scroll(X, Y, W, H)
end

function Browser:Scroll(X, Y, W, H)
    local delta = input.GetMouseWheelDelta()
    -- Positive delta: scroll up (move content down)
    -- Negative delta: scroll down (move content up)

    if delta ~= 0 then
        local totalContentHeight = 0
        for _, typedElement in pairs(self.TypedElements) do
            totalContentHeight = totalContentHeight + typedElement.H
        end

        local visibleHeight = H - 30
        local maxScrollOffset = math.max(totalContentHeight - visibleHeight, 0)

        if delta > 0 then
            -- Scrolling up: decrease ScrollOffset
            self.ScrollOffset = math.max(self.ScrollOffset - 30, 0)
        elseif delta < 0 then
            -- Scrolling down: increase ScrollOffset
            self.ScrollOffset = math.min(self.ScrollOffset + 30, maxScrollOffset)
        end
    end
end

function Browser:Load(typedElements)
    for _, typedElement in pairs(typedElements) do
        if typedElement:GetHTMLElement().name == "title" then
            self.Title = typedElement:GetContent()
            typedElements[_] = nil
        end
    end

    self.TypedElements = typedElements
end