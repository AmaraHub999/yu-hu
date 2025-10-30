local DiscordLib = {}
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local HttpService = game:GetService("HttpService")

-- สีที่กำหนดเอง (Cool Blue)
local PRIMARY_BLUE = Color3.fromRGB(52, 152, 219)
local BACKGROUND_DARK = Color3.fromRGB(32, 34, 37)
local BACKGROUND_MID = Color3.fromRGB(47, 49, 54)
local BACKGROUND_LIGHT = Color3.fromRGB(54, 57, 63)
local TEXT_LIGHT = Color3.fromRGB(255, 255, 255)
local TEXT_MUTED = Color3.fromRGB(184, 186, 189)
local BUTTON_HOVER = Color3.fromRGB(41, 128, 185)

local pfp
local user
local tag
local userinfo = {}

pcall(function()
    userinfo = HttpService:JSONDecode(readfile("discordlibinfo.txt"));
end)

pfp = userinfo["pfp"] or "https://www.roblox.com/headshot-thumbnail/image?userId=".. game.Players.LocalPlayer.UserId .."&width=420&height=420&format=png"
user =  userinfo["user"] or game.Players.LocalPlayer.Name
tag = userinfo["tag"] or tostring(math.random(1000,9999))

local function SaveInfo()
    userinfo["pfp"] = pfp
    userinfo["user"] = user
    userinfo["tag"] = tag
    writefile("discordlibinfo.txt", HttpService:JSONEncode(userinfo));
end

local function MakeDraggable(topbarobject, object)
    local Dragging = nil
    local DragInput = nil
    local DragStart = nil
    local StartPosition = nil

    local function Update(input)
        local Delta = input.Position - DragStart
        local pos =
            UDim2.new(
                StartPosition.X.Scale,
                StartPosition.X.Offset + Delta.X,
                StartPosition.Y.Scale,
                StartPosition.Y.Offset + Delta.Y
            )
        object.Position = pos
    end

    topbarobject.InputBegan:Connect(
        function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                Dragging = true
                DragStart = input.Position
                StartPosition = object.Position

                input.Changed:Connect(
                    function()
                        if input.UserInputState == Enum.UserInputState.End then
                            Dragging = false
                        end
                    end
                )
            end
        end
    )

    topbarobject.InputChanged:Connect(
        function(input)
            if
                input.UserInputType == Enum.UserInputType.MouseMovement or
                    input.UserInputType == Enum.UserInputType.Touch
            then
                DragInput = input
            end
        end
    )

    UserInputService.InputChanged:Connect(
        function(input)
            if input == DragInput and Dragging then
                Update(input)
            end
        end
    )
end

local Discord = Instance.new("ScreenGui")
Discord.Name = "Discord"
Discord.Parent = game.CoreGui
Discord.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

function DiscordLib:Window(text)
    local currentservertoggled = ""
    local minimized = false
    local fs = false
    local settingsopened = false
    
    -- Main Frame with Rounded Corners
    local MainFrame = Instance.new("Frame")
    local MainFrameCorner = Instance.new("UICorner")
    
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = Discord
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.BackgroundColor3 = BACKGROUND_DARK
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    MainFrame.Size = UDim2.new(0, 681, 0, 396)

    MainFrameCorner.CornerRadius = UDim.new(0, 8)
    MainFrameCorner.Name = "MainFrameCorner"
    MainFrameCorner.Parent = MainFrame

    -- Top Frame with Rounded Corners
    local TopFrame = Instance.new("Frame")
    local TopFrameCorner = Instance.new("UICorner")
    
    TopFrame.Name = "TopFrame"
    TopFrame.Parent = MainFrame
    TopFrame.BackgroundColor3 = BACKGROUND_DARK
    TopFrame.BackgroundTransparency = 0.000
    TopFrame.BorderSizePixel = 0
    TopFrame.Position = UDim2.new(0, 0, 0, 0)
    TopFrame.Size = UDim2.new(1, 0, 0, 22)

    TopFrameCorner.CornerRadius = UDim.new(0, 8)
    TopFrameCorner.Name = "TopFrameCorner"
    TopFrameCorner.Parent = TopFrame

    local Title = Instance.new("TextLabel")
    local CloseBtn = Instance.new("TextButton")
    local CloseBtnCorner = Instance.new("UICorner")
    local CloseIcon = Instance.new("ImageLabel")
    local MinimizeBtn = Instance.new("TextButton")
    local MinimizeBtnCorner = Instance.new("UICorner")
    local MinimizeIcon = Instance.new("ImageLabel")
    local ServersHolder = Instance.new("Folder")
    local Userpad = Instance.new("Frame")
    local UserpadCorner = Instance.new("UICorner")
    local UserIcon = Instance.new("Frame")
    local UserIconCorner = Instance.new("UICorner")
    local UserImage = Instance.new("ImageLabel")
    local UserCircleImage = Instance.new("ImageLabel")
    local UserName = Instance.new("TextLabel")
    local UserTag = Instance.new("TextLabel")
    local ServersHoldFrame = Instance.new("Frame")
    local ServersHoldFrameCorner = Instance.new("UICorner")
    local ServersHold = Instance.new("ScrollingFrame")
    local ServersHoldLayout = Instance.new("UIListLayout")
    local ServersHoldPadding = Instance.new("UIPadding")
    local TopFrameHolder = Instance.new("Frame")
    
    -- Amara Hub Logo & Title
    local HubLogo = Instance.new("ImageLabel")
    local HubTitle = Instance.new("TextLabel")

    TopFrameHolder.Name = "TopFrameHolder"
    TopFrameHolder.Parent = TopFrame
    TopFrameHolder.BackgroundColor3 = BACKGROUND_DARK
    TopFrameHolder.BackgroundTransparency = 1.000
    TopFrameHolder.BorderSizePixel = 0
    TopFrameHolder.Position = UDim2.new(0, 0, 0, 0)
    TopFrameHolder.Size = UDim2.new(1, 0, 1, 0)

    -- Hub Logo
    HubLogo.Name = "HubLogo"
    HubLogo.Parent = TopFrame
    HubLogo.BackgroundColor3 = TEXT_LIGHT
    HubLogo.BackgroundTransparency = 1.000
    HubLogo.Position = UDim2.new(0.01, 0, 0.1, 0)
    HubLogo.Size = UDim2.new(0, 18, 0, 18)
    HubLogo.Image = "rbxassetid://6034407084"
    HubLogo.ImageColor3 = PRIMARY_BLUE

    -- Hub Title
    HubTitle.Name = "HubTitle"
    HubTitle.Parent = TopFrame
    HubTitle.BackgroundColor3 = TEXT_LIGHT
    HubTitle.BackgroundTransparency = 1.000
    HubTitle.Position = UDim2.new(0.045, 0, 0, 0)
    HubTitle.Size = UDim2.new(0, 100, 0, 23)
    HubTitle.Font = Enum.Font.GothamBold
    HubTitle.Text = "Amara Hub"
    HubTitle.TextColor3 = TEXT_LIGHT
    HubTitle.TextSize = 14.000
    HubTitle.TextXAlignment = Enum.TextXAlignment.Left

    Title.Name = "Title"
    Title.Parent = TopFrame
    Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Title.BackgroundTransparency = 1.000
    Title.Position = UDim2.new(0.18, 0, 0, 0)
    Title.Size = UDim2.new(0, 192, 0, 23)
    Title.Font = Enum.Font.GothamSemibold
    Title.Text = text
    Title.TextColor3 = TEXT_MUTED
    Title.TextSize = 13.000
    Title.TextXAlignment = Enum.TextXAlignment.Left

    -- Close Button with Rounded Corners
    CloseBtn.Name = "CloseBtn"
    CloseBtn.Parent = TopFrame
    CloseBtn.BackgroundColor3 = BACKGROUND_DARK
    CloseBtn.BackgroundTransparency = 0
    CloseBtn.Position = UDim2.new(0.959, 0, 0, 0)
    CloseBtn.Size = UDim2.new(0, 28, 0, 22)
    CloseBtn.Font = Enum.Font.Gotham
    CloseBtn.Text = ""
    CloseBtn.TextColor3 = TEXT_LIGHT
    CloseBtn.TextSize = 14.000
    CloseBtn.BorderSizePixel = 0
    CloseBtn.AutoButtonColor = false

    CloseBtnCorner.CornerRadius = UDim.new(0, 4)
    CloseBtnCorner.Name = "CloseBtnCorner"
    CloseBtnCorner.Parent = CloseBtn

    CloseIcon.Name = "CloseIcon"
    CloseIcon.Parent = CloseBtn
    CloseIcon.BackgroundColor3 = TEXT_LIGHT
    CloseIcon.BackgroundTransparency = 1.000
    CloseIcon.Position = UDim2.new(0.18, 0, 0.12, 0)
    CloseIcon.Size = UDim2.new(0, 17, 0, 17)
    CloseIcon.Image = "http://www.roblox.com/asset/?id=6035047409"
    CloseIcon.ImageColor3 = TEXT_MUTED

    -- Minimize Button with Rounded Corners
    MinimizeBtn.Name = "MinimizeButton"
    MinimizeBtn.Parent = TopFrame
    MinimizeBtn.BackgroundColor3 = BACKGROUND_DARK
    MinimizeBtn.BackgroundTransparency = 0
    MinimizeBtn.Position = UDim2.new(0.918, 0, 0, 0)
    MinimizeBtn.Size = UDim2.new(0, 28, 0, 22)
    MinimizeBtn.Font = Enum.Font.Gotham
    MinimizeBtn.Text = ""
    MinimizeBtn.TextColor3 = TEXT_LIGHT
    MinimizeBtn.TextSize = 14.000
    MinimizeBtn.BorderSizePixel = 0
    MinimizeBtn.AutoButtonColor = false

    MinimizeBtnCorner.CornerRadius = UDim.new(0, 4)
    MinimizeBtnCorner.Name = "MinimizeBtnCorner"
    MinimizeBtnCorner.Parent = MinimizeBtn

    MinimizeIcon.Name = "MinimizeLabel"
    MinimizeIcon.Parent = MinimizeBtn
    MinimizeIcon.BackgroundColor3 = TEXT_LIGHT
    MinimizeIcon.BackgroundTransparency = 1.000
    MinimizeIcon.Position = UDim2.new(0.18, 0, 0.12, 0)
    MinimizeIcon.Size = UDim2.new(0, 17, 0, 17)
    MinimizeIcon.Image = "http://www.roblox.com/asset/?id=6035067836"
    MinimizeIcon.ImageColor3 = TEXT_MUTED

    ServersHolder.Name = "ServersHolder"
    ServersHolder.Parent = MainFrame

    -- User Panel with Rounded Corners
    Userpad.Name = "Userpad"
    Userpad.Parent = TopFrameHolder
    Userpad.BackgroundColor3 = BACKGROUND_MID
    Userpad.BorderSizePixel = 0
    Userpad.Position = UDim2.new(0.106, 0, 1, 0)
    Userpad.Size = UDim2.new(0, 179, 0, 43)

    UserpadCorner.CornerRadius = UDim.new(0, 6)
    UserpadCorner.Name = "UserpadCorner"
    UserpadCorner.Parent = Userpad

    UserIcon.Name = "UserIcon"
    UserIcon.Parent = Userpad
    UserIcon.BackgroundColor3 = BACKGROUND_DARK
    UserIcon.BorderSizePixel = 0
    UserIcon.Position = UDim2.new(0.034, 0, 0.12, 0)
    UserIcon.Size = UDim2.new(0, 32, 0, 32)

    UserIconCorner.CornerRadius = UDim.new(1, 8)
    UserIconCorner.Name = "UserIconCorner"
    UserIconCorner.Parent = UserIcon

    UserImage.Name = "UserImage"
    UserImage.Parent = UserIcon
    UserImage.BackgroundColor3 = TEXT_LIGHT
    UserImage.BackgroundTransparency = 1.000
    UserImage.Size = UDim2.new(0, 32, 0, 32)
    UserImage.Image = pfp 
    
    UserCircleImage.Name = "UserImage"
    UserCircleImage.Parent = UserImage
    UserCircleImage.BackgroundColor3 = TEXT_LIGHT
    UserCircleImage.BackgroundTransparency = 1.000
    UserCircleImage.Size = UDim2.new(0, 32, 0, 32)
    UserCircleImage.Image = "rbxassetid://4031889928"
    UserCircleImage.ImageColor3 = BACKGROUND_MID

    UserName.Name = "UserName"
    UserName.Parent = Userpad
    UserName.BackgroundColor3 = TEXT_LIGHT
    UserName.BackgroundTransparency = 1.000
    UserName.BorderSizePixel = 0
    UserName.Position = UDim2.new(0.23, 0, 0.11, 0)
    UserName.Size = UDim2.new(0, 98, 0, 17)
    UserName.Font = Enum.Font.GothamSemibold
    UserName.TextColor3 = TEXT_LIGHT
    UserName.TextSize = 13.000
    UserName.TextXAlignment = Enum.TextXAlignment.Left
    UserName.ClipsDescendants = true

    UserTag.Name = "UserTag"
    UserTag.Parent = Userpad
    UserTag.BackgroundColor3 = TEXT_LIGHT
    UserTag.BackgroundTransparency = 1.000
    UserTag.BorderSizePixel = 0
    UserTag.Position = UDim2.new(0.23, 0, 0.45, 0)
    UserTag.Size = UDim2.new(0, 95, 0, 17)
    UserTag.Font = Enum.Font.Gotham
    UserTag.TextColor3 = TEXT_MUTED
    UserTag.TextSize = 13.000
    UserTag.TextTransparency = 0.000
    UserTag.TextXAlignment = Enum.TextXAlignment.Left
    
    UserName.Text = user
    UserTag.Text = "#" .. tag

    -- Servers Frame with Rounded Corners
    ServersHoldFrame.Name = "ServersHoldFrame"
    ServersHoldFrame.Parent = MainFrame
    ServersHoldFrame.BackgroundColor3 = Color3.fromRGB(40, 43, 46)
    ServersHoldFrame.BackgroundTransparency = 0.000
    ServersHoldFrame.BorderColor3 = Color3.fromRGB(27, 42, 53)
    ServersHoldFrame.Size = UDim2.new(0, 71, 1, 0)

    ServersHoldFrameCorner.CornerRadius = UDim.new(0, 8)
    ServersHoldFrameCorner.Name = "ServersHoldFrameCorner"
    ServersHoldFrameCorner.Parent = ServersHoldFrame

    ServersHold.Name = "ServersHold"
    ServersHold.Parent = ServersHoldFrame
    ServersHold.Active = true
    ServersHold.BackgroundColor3 = TEXT_LIGHT
    ServersHold.BackgroundTransparency = 1.000
    ServersHold.BorderSizePixel = 0
    ServersHold.Position = UDim2.new(0, 0, 0, 0)
    ServersHold.Size = UDim2.new(1, 0, 1, 0)
    ServersHold.ScrollBarThickness = 2
    ServersHold.ScrollBarImageColor3 = PRIMARY_BLUE
    ServersHold.ScrollBarImageTransparency = 0.8
    ServersHold.CanvasSize = UDim2.new(0, 0, 0, 0)

    ServersHoldLayout.Name = "ServersHoldLayout"
    ServersHoldLayout.Parent = ServersHold
    ServersHoldLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ServersHoldLayout.Padding = UDim.new(0, 7)

    ServersHoldPadding.Name = "ServersHoldPadding"
    ServersHoldPadding.Parent = ServersHold
    ServersHoldPadding.PaddingTop = UDim.new(0, 7)
    ServersHoldPadding.PaddingBottom = UDim.new(0, 7)

    -- Button Animations
    CloseBtn.MouseButton1Click:Connect(
        function()
            TweenService:Create(
                MainFrame,
                TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In),
                {Size = UDim2.new(0, 0, 0, 0)}
            ):Play()
            wait(0.3)
            MainFrame.Visible = false
        end
    )

    CloseBtn.MouseEnter:Connect(
        function()
            TweenService:Create(
                CloseBtn,
                TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {BackgroundColor3 = Color3.fromRGB(240, 71, 71)}
            ):Play()
        end
    )

    CloseBtn.MouseLeave:Connect(
        function()
            TweenService:Create(
                CloseBtn,
                TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {BackgroundColor3 = BACKGROUND_DARK}
            ):Play()
        end
    )

    MinimizeBtn.MouseEnter:Connect(
        function()
            TweenService:Create(
                MinimizeBtn,
                TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {BackgroundColor3 = BACKGROUND_MID}
            ):Play()
        end
    )

    MinimizeBtn.MouseLeave:Connect(
        function()
            TweenService:Create(
                MinimizeBtn,
                TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {BackgroundColor3 = BACKGROUND_DARK}
            ):Play()
        end
    )

    MinimizeBtn.MouseButton1Click:Connect(
        function()
            if minimized == false then
                TweenService:Create(
                    MainFrame,
                    TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                    {Size = UDim2.new(0, 681, 0, 22)}
                ):Play()
            else
                TweenService:Create(
                    MainFrame,
                    TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                    {Size = UDim2.new(0, 681, 0, 396)}
                ):Play()
            end
            minimized = not minimized
        end
    )
    
    -- Settings Button
    local SettingsOpenBtn = Instance.new("TextButton")
    local SettingsOpenBtnCorner = Instance.new("UICorner")
    local SettingsOpenBtnIco = Instance.new("ImageLabel")
    
    SettingsOpenBtn.Name = "SettingsOpenBtn"
    SettingsOpenBtn.Parent = Userpad
    SettingsOpenBtn.BackgroundColor3 = PRIMARY_BLUE
    SettingsOpenBtn.BackgroundTransparency = 1.000
    SettingsOpenBtn.Position = UDim2.new(0.85, 0, 0.28, 0)
    SettingsOpenBtn.Size = UDim2.new(0, 18, 0, 18)
    SettingsOpenBtn.Font = Enum.Font.SourceSans
    SettingsOpenBtn.Text = ""
    SettingsOpenBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
    SettingsOpenBtn.TextSize = 14.000
    
    SettingsOpenBtnCorner.CornerRadius = UDim.new(0, 4)
    SettingsOpenBtnCorner.Name = "SettingsOpenBtnCorner"
    SettingsOpenBtnCorner.Parent = SettingsOpenBtn
    
    SettingsOpenBtn.MouseEnter:Connect(function()
        TweenService:Create(
            SettingsOpenBtn,
            TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {BackgroundTransparency = 0.7}
        ):Play()
        SettingsOpenBtnIco.ImageColor3 = PRIMARY_BLUE
    end)
    
    SettingsOpenBtn.MouseLeave:Connect(function()
        TweenService:Create(
            SettingsOpenBtn,
            TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {BackgroundTransparency = 1}
        ):Play()
        SettingsOpenBtnIco.ImageColor3 = TEXT_MUTED
    end)

    SettingsOpenBtnIco.Name = "SettingsOpenBtnIco"
    SettingsOpenBtnIco.Parent = SettingsOpenBtn
    SettingsOpenBtnIco.BackgroundColor3 = TEXT_LIGHT
    SettingsOpenBtnIco.BackgroundTransparency = 1.000
    SettingsOpenBtnIco.Size = UDim2.new(1, 0, 1, 0)
    SettingsOpenBtnIco.Image = "http://www.roblox.com/asset/?id=6031280882"
    SettingsOpenBtnIco.ImageColor3 = TEXT_MUTED

    MakeDraggable(TopFrame, MainFrame)

    return {
        AddServer = function(imageid, text)
            local ServerBtn = Instance.new("ImageButton")
            local ServerBtnCorner = Instance.new("UICorner")
            local ServerBtnIndicator = Instance.new("Frame")
            local ServerBtnIndicatorCorner = Instance.new("UICorner")

            ServerBtn.Name = text
            ServerBtn.Parent = ServersHold
            ServerBtn.BackgroundColor3 = BACKGROUND_DARK
            ServerBtn.BorderSizePixel = 0
            ServerBtn.Size = UDim2.new(0, 50, 0, 50)
            ServerBtn.Image = "rbxassetid://" .. imageid
            ServerBtn.AutoButtonColor = false
            
            ServerBtnCorner.CornerRadius = UDim.new(1, 0)
            ServerBtnCorner.Name = "ServerBtnCorner"
            ServerBtnCorner.Parent = ServerBtn
            
            ServerBtn.MouseEnter:Connect(function()
                if currentservertoggled ~= text then
                    TweenService:Create(
                        ServerBtn,
                        TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                        {BackgroundColor3 = PRIMARY_BLUE}
                    ):Play()
                    TweenService:Create(
                        ServerBtnCorner,
                        TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                        {CornerRadius = UDim.new(0, 16)}
                    ):Play()
                end
            end)
            
            ServerBtn.MouseLeave:Connect(function()
                if currentservertoggled ~= text then
                    TweenService:Create(
                        ServerBtn,
                        TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                        {BackgroundColor3 = BACKGROUND_DARK}
                    ):Play()
                    TweenService:Create(
                        ServerBtnCorner,
                        TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                        {CornerRadius = UDim.new(1, 0)}
                    ):Play()
                end
            end)
            
            ServerBtn.MouseButton1Click:Connect(function()
                if currentservertoggled == text then
                    currentservertoggled = ""
                    TweenService:Create(
                        ServerBtnCorner,
                        TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                        {CornerRadius = UDim.new(1, 0)}
                    ):Play()
                    TweenService:Create(
                        ServerBtn,
                        TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                        {BackgroundColor3 = BACKGROUND_DARK}
                    ):Play()
                    TweenService:Create(
                        ServerBtnIndicator,
                        TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                        {Size = UDim2.new(0, 0, 0, 0)}
                    ):Play()
                else
                    for i, v in pairs(ServersHold:GetChildren()) do
                        if v:IsA("ImageButton") and v.Name == currentservertoggled then
                            TweenService:Create(
                                v.UICorner,
                                TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                                {CornerRadius = UDim.new(1, 0)}
                            ):Play()
                            TweenService:Create(
                                v,
                                TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                                {BackgroundColor3 = BACKGROUND_DARK}
                            ):Play()
                            v.ServerBtnIndicator.Size = UDim2.new(0, 0, 0, 0)
                        end
                    end
                    
                    currentservertoggled = text
                    TweenService:Create(
                        ServerBtnCorner,
                        TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                        {CornerRadius = UDim.new(0, 16)}
                    ):Play()
                    TweenService:Create(
                        ServerBtn,
                        TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                        {BackgroundColor3 = PRIMARY_BLUE}
                    ):Play()
                    TweenService:Create(
                        ServerBtnIndicator,
                        TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                        {Size = UDim2.new(0, 4, 0, 30)}
                    ):Play()
                end
            end)
            
            ServerBtnIndicator.Name = "ServerBtnIndicator"
            ServerBtnIndicator.Parent = ServerBtn
            ServerBtnIndicator.AnchorPoint = Vector2.new(0, 0.5)
            ServerBtnIndicator.BackgroundColor3 = TEXT_LIGHT
            ServerBtnIndicator.BorderSizePixel = 0
            ServerBtnIndicator.Position = UDim2.new(-0.08, 0, 0.5, 0)
            ServerBtnIndicator.Size = UDim2.new(0, 0, 0, 0)

            ServerBtnIndicatorCorner.CornerRadius = UDim.new(0, 3)
            ServerBtnIndicatorCorner.Name = "ServerBtnIndicatorCorner"
            ServerBtnIndicatorCorner.Parent = ServerBtnIndicator
            
            return {
                Button = ServerBtn
            }
        end,
        
        Window = MainFrame,
        ServersHolder = ServersHolder,
        SettingsOpenBtn = SettingsOpenBtn,
        ServersHoldFrame = ServersHoldFrame
    }
end

return DiscordLib
