
H1Element = setmetatable({}, { __index = Element })
H1Element.__index = H1Element

function H1Element.new(element)
    local o = Element.new(element)
    o.Type = "H1"
    o.Font = draw.CreateFont("Bahnschrift", 32, 100)
    o = o or {}
    setmetatable(o, H1Element)
    
    return o
end

function H1Element:Draw(X, Y, W, H)
    draw.SetFont(self.Font)
    local content = self:GetContent()
    local words = {}
    local wordStart = 1

    -- Split content into words
    for i = 1, #content do
        if content:sub(i, i) == " " or i == #content then
            table.insert(words, content:sub(wordStart, i))
            wordStart = i + 1
        end
    end

    -- Define padding values
    local paddingLeft = self.Padding.Left
    local paddingRight = self.Padding.Right
    local paddingTop = self.Padding.Top
    local paddingBottom = self.Padding.Bottom
    local lineSpacing = 4 -- Adjust this value to control the space between lines

    -- Calculate available width and height
    local availableWidth = W - paddingLeft - paddingRight
    local availableHeight = H - paddingTop - paddingBottom

    -- Wrap the text based on the available width
    local lines = wrapText(words, availableWidth)
    local maxWidth = 0
    local lineHeight, _ = draw.GetTextSize("A") -- Approximate line height
    local totalHeight = 0
    local yOffset = Y + paddingTop

    -- Calculate the maximum width and total height required
    for _, line in ipairs(lines) do
        local lineWidth, _ = draw.GetTextSize(line)
        if lineWidth > maxWidth then
            maxWidth = lineWidth
        end
        totalHeight = totalHeight + lineHeight + lineSpacing
    end

    -- Update self.W and self.H
    self.W = maxWidth + paddingLeft + paddingRight
    self.H = totalHeight + paddingTop + paddingBottom

    -- Render each line of text
    for _, line in ipairs(lines) do
        Renderer:Text({X + paddingLeft, yOffset}, {0, 0, 0, 255}, line)
        yOffset = yOffset + lineHeight + lineSpacing
    end

    -- Optionally update self.X and self.Y if needed
    self.X = X
    self.Y = Y
end


