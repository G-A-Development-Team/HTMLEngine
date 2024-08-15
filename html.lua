xpcall(function()
    function using(pkgn) 
        file.Write("\\using/json.lua", http.Get("https://raw.githubusercontent.com/G-A-Development-Team/libs/main/json.lua")) 
        LoadScript("\\using/json.lua")
        local pkg = json.decode(http.Get("https://raw.githubusercontent.com/G-A-Development-Team/Using/main/using.json"))["pkgs"][pkgn] 
        if pkg ~= nil then
            file.Write("\\using/" .. pkgn .. ".lua", http.Get(pkg)) 
            LoadScript("\\using/" .. pkgn .. ".lua") 
        else 
            print("[using] package doesn't exist. {" .. pkgn .. "}")
        end
    end

    using "Renderer"
    using "LoadLocal"
    using "Move-Resize"
    using "HTMLParser"
    using "HashTable"
    using "MoreLibs"

    LoadLocal("Element")
    LoadLocal("TitleElement")
    LoadLocal("Browser")
    
    local htmlBrowser = Browser.new()
    htmlBrowser:Init()
    
    local testHTML = [[
    <!DOCTYPE html>
    <html>
    <head>
    <title>Page Title</title>
    </head>
    <body>
    
    <h1>Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur, from a Lorem Ipsum passage, and going through the cites of the word in classical literature, discovered the undoubtable source. Lorem Ipsum comes from sections 1.10.32 and 1.10.33 of "de Finibus Bonorum</h1>
    <h1>The standard chunk of Lorem Ipsum used since the 1500s is reproduced below for those interested. Sections 1.10.32 and 1.10.33 from "de Finibus Bonorum et Malorum" by Cicero are also reproduced in their exact original form, accompanied by English versions from the 1914 translation by H. Rackham.</h1>
    
    <div class="asd" id="asd">
        <div>
            <p>This is a paragraph.</p>
        </div>
    </div>
    <div>
    <p>This is a paragraph.</p>
    </div>
    
    </body>
    </html>
    ]]

    -- Load HTML elements into a unique table with a hash identifing them. 
    -- This means we are able to hash the parent of the element and line it up correctly
    local hashedElements = {}

    local root = HtmlParser.parse(testHTML)
    local elements = root("*")
    for _, element in ipairs(elements) do
        local current = hashTable(element)
        hashedElements[current] = element
    end

    -- Convert the hashedElements to a table of elements with found types
    local typedElements = {}

    for _, element in pairs(hashedElements) do
        local pHash = hashTable(element.parent)
        if hashedElements[pHash] ~= nil then
            local type = nil
            if element.name == "title" then
                type = TitleElement.new(element)
                type:SetContent(element:getcontent())
            elseif element.name == "h1" then
                type = H1Element.new(element)
                type:SetContent(element:getcontent())
            elseif element.name == "body" then
                htmlBrowser.BodyHash = hashTable(element)
            end
            if type ~= nil then
                typedElements[_] = type
            end

            --print("[" .. _ .. "] I have a parent " .. element.name .. " [" .. pHash .. "]")
        else
            --print("[" .. _ .. "] I'm god " .. element.name)
        end
    end

    htmlBrowser:Load(typedElements)

    table.insert(windows, htmlBrowser)
    callbacks.Register("Unload", function()
        for i = 1, #windows do
            table.remove(windows, i)
        end
        windows = nil
    end)
end, print)