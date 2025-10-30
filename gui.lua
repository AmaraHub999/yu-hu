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
local BUTTON_HOVER = Color3.fromRGB(41, 128, 185) -- Darker blue for hover

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
	local MainFrame = Instance.new("Frame")
	local TopFrame = Instance.new("Frame")
	local Title = Instance.new("TextLabel")
	local CloseBtn = Instance.new("TextButton")
	local CloseIcon = Instance.new("ImageLabel")
	local MinimizeBtn = Instance.new("TextButton")
	local MinimizeIcon = Instance.new("ImageLabel")
	local ServersHolder = Instance.new("Folder")
	local Userpad = Instance.new("Frame")
	local UserIcon = Instance.new("Frame")
	local UserIconCorner = Instance.new("UICorner")
	local UserImage = Instance.new("ImageLabel")
	local UserCircleImage = Instance.new("ImageLabel")
	local UserName = Instance.new("TextLabel")
	local UserTag = Instance.new("TextLabel")
	local ServersHoldFrame = Instance.new("Frame")
	local ServersHold = Instance.new("ScrollingFrame")
	local ServersHoldLayout = Instance.new("UIListLayout")
	local ServersHoldPadding = Instance.new("UIPadding")
	local TopFrameHolder = Instance.new("Frame")
	
	-- **Amara Hub - Logo & Title**
	local HubLogo = Instance.new("ImageLabel")
	local HubTitle = Instance.new("TextLabel")

	MainFrame.Name = "MainFrame"
	MainFrame.Parent = Discord
	MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	MainFrame.BackgroundColor3 = BACKGROUND_DARK -- สีเข้ม
	MainFrame.BorderSizePixel = 0
	MainFrame.ClipsDescendants = true
	MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
	MainFrame.Size = UDim2.new(0, 681, 0, 396)

	TopFrame.Name = "TopFrame"
	TopFrame.Parent = MainFrame
	TopFrame.BackgroundColor3 = BACKGROUND_DARK
	TopFrame.BackgroundTransparency = 0.000 -- ทำให้ทึบ
	TopFrame.BorderSizePixel = 0
	TopFrame.Position = UDim2.new(0, 0, 0, 0)
	TopFrame.Size = UDim2.new(1, 0, 0, 22) -- ปรับเป็น 1, 0 เพื่อให้เต็มความกว้าง
	
	TopFrameHolder.Name = "TopFrameHolder"
	TopFrameHolder.Parent = TopFrame
	TopFrameHolder.BackgroundColor3 = BACKGROUND_DARK
	TopFrameHolder.BackgroundTransparency = 1.000
	TopFrameHolder.BorderSizePixel = 0
	TopFrameHolder.Position = UDim2.new(0, 0, 0, 0)
	TopFrameHolder.Size = UDim2.new(1, 0, 1, 0) -- ปรับเป็น 1, 0 เพื่อให้เต็มความกว้างและความสูง
	
	-- **Hub Logo**
	HubLogo.Name = "HubLogo"
	HubLogo.Parent = TopFrame
	HubLogo.BackgroundColor3 = TEXT_LIGHT
	HubLogo.BackgroundTransparency = 1.000
	HubLogo.Position = UDim2.new(0.01, 0, 0.1, 0)
	HubLogo.Size = UDim2.new(0, 18, 0, 18)
	-- **คุณสามารถใส่ Asset ID ของโลโก้ Amara Hub ของคุณที่นี่**
	HubLogo.Image = "rbxassetid://6034407084" -- ตัวอย่างไอคอน (รูปแว่นขยาย)
	HubLogo.ImageColor3 = PRIMARY_BLUE -- สีฟ้าเท่ๆ

	-- **Hub Title**
	HubTitle.Name = "HubTitle"
	HubTitle.Parent = TopFrame
	HubTitle.BackgroundColor3 = TEXT_LIGHT
	HubTitle.BackgroundTransparency = 1.000
	HubTitle.Position = UDim2.new(0.045, 0, 0, 0) -- ขยับให้เว้นจากโลโก้
	HubTitle.Size = UDim2.new(0, 100, 0, 23)
	HubTitle.Font = Enum.Font.GothamBold -- ฟอนต์เท่ๆ
	HubTitle.Text = "Amara Hub" -- ชื่อ Hub ใหม่
	HubTitle.TextColor3 = TEXT_LIGHT -- สีขาว
	HubTitle.TextSize = 14.000
	HubTitle.TextXAlignment = Enum.TextXAlignment.Left

	Title.Name = "Title"
	Title.Parent = TopFrame
	Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Title.BackgroundTransparency = 1.000
	Title.Position = UDim2.new(0.18, 0, 0, 0) -- ขยับไปทางขวา
	Title.Size = UDim2.new(0, 192, 0, 23)
	Title.Font = Enum.Font.GothamSemibold -- ฟอนต์เท่ๆ
	Title.Text = text
	Title.TextColor3 = TEXT_MUTED -- สีเทาที่ดูจางลง
	Title.TextSize = 13.000
	Title.TextXAlignment = Enum.TextXAlignment.Left

	CloseBtn.Name = "CloseBtn"
	CloseBtn.Parent = TopFrame
	CloseBtn.BackgroundColor3 = BACKGROUND_DARK
	CloseBtn.BackgroundTransparency = 0
	CloseBtn.Position = UDim2.new(0.959, 0, 0, 0) -- ปรับตำแหน่ง
	CloseBtn.Size = UDim2.new(0, 28, 0, 22)
	CloseBtn.Font = Enum.Font.Gotham
	CloseBtn.Text = ""
	CloseBtn.TextColor3 = TEXT_LIGHT
	CloseBtn.TextSize = 14.000
	CloseBtn.BorderSizePixel = 0
	CloseBtn.AutoButtonColor = false

	CloseIcon.Name = "CloseIcon"
	CloseIcon.Parent = CloseBtn
	CloseIcon.BackgroundColor3 = TEXT_LIGHT
	CloseIcon.BackgroundTransparency = 1.000
	CloseIcon.Position = UDim2.new(0.18, 0, 0.12, 0)
	CloseIcon.Size = UDim2.new(0, 17, 0, 17)
	CloseIcon.Image = "http://www.roblox.com/asset/?id=6035047409"
	CloseIcon.ImageColor3 = TEXT_MUTED -- เปลี่ยนสีไอคอน

	MinimizeBtn.Name = "MinimizeButton"
	MinimizeBtn.Parent = TopFrame
	MinimizeBtn.BackgroundColor3 = BACKGROUND_DARK
	MinimizeBtn.BackgroundTransparency = 0
	MinimizeBtn.Position = UDim2.new(0.918, 0, 0, 0) -- ปรับตำแหน่ง
	MinimizeBtn.Size = UDim2.new(0, 28, 0, 22)
	MinimizeBtn.Font = Enum.Font.Gotham
	MinimizeBtn.Text = ""
	MinimizeBtn.TextColor3 = TEXT_LIGHT
	MinimizeBtn.TextSize = 14.000
	MinimizeBtn.BorderSizePixel = 0
	MinimizeBtn.AutoButtonColor = false

	MinimizeIcon.Name = "MinimizeLabel"
	MinimizeIcon.Parent = MinimizeBtn
	MinimizeIcon.BackgroundColor3 = TEXT_LIGHT
	MinimizeIcon.BackgroundTransparency = 1.000
	MinimizeIcon.Position = UDim2.new(0.18, 0, 0.12, 0)
	MinimizeIcon.Size = UDim2.new(0, 17, 0, 17)
	MinimizeIcon.Image = "http://www.roblox.com/asset/?id=6035067836"
	MinimizeIcon.ImageColor3 = TEXT_MUTED -- เปลี่ยนสีไอคอน

	ServersHolder.Name = "ServersHolder"
	ServersHolder.Parent = MainFrame -- ย้ายมาเป็นลูกของ MainFrame เพื่อให้ถูกบังเมื่อย่อหน้าต่าง

	Userpad.Name = "Userpad"
	Userpad.Parent = TopFrameHolder
	Userpad.BackgroundColor3 = BACKGROUND_MID -- สีที่สว่างขึ้นเล็กน้อย
	Userpad.BorderSizePixel = 0
	Userpad.Position = UDim2.new(0.106, 0, 1, 0) -- ขยับลงมาด้านล่าง TopFrame
	Userpad.Size = UDim2.new(0, 179, 0, 43)

	UserIcon.Name = "UserIcon"
	UserIcon.Parent = Userpad
	UserIcon.BackgroundColor3 = BACKGROUND_DARK -- สีเข้มเล็กน้อย
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
	UserCircleImage.ImageColor3 = BACKGROUND_MID -- สีให้เข้ากับพื้นหลัง

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
	UserTag.TextTransparency = 0.000 -- เอา Transparency ออก
	UserTag.TextXAlignment = Enum.TextXAlignment.Left
	
	UserName.Text = user
	UserTag.Text = "#" .. tag

	ServersHoldFrame.Name = "ServersHoldFrame"
	ServersHoldFrame.Parent = MainFrame
	ServersHoldFrame.BackgroundColor3 = Color3.fromRGB(40, 43, 46) -- สีที่สว่างขึ้นเล็กน้อยเพื่อแยกจากพื้นหลังหลัก
	ServersHoldFrame.BackgroundTransparency = 0.000
	ServersHoldFrame.BorderColor3 = Color3.fromRGB(27, 42, 53)
	ServersHoldFrame.Size = UDim2.new(0, 71, 1, 0) -- เต็มความสูง

	ServersHold.Name = "ServersHold"
	ServersHold.Parent = ServersHoldFrame
	ServersHold.Active = true
	ServersHold.BackgroundColor3 = TEXT_LIGHT
	ServersHold.BackgroundTransparency = 1.000
	ServersHold.BorderSizePixel = 0
	ServersHold.Position = UDim2.new(0, 0, 0, 0) -- เต็มพื้นที่ ServersHoldFrame
	ServersHold.Size = UDim2.new(1, 0, 1, 0)
	ServersHold.ScrollBarThickness = 2 -- เพิ่มความหนา ScrollBar
	ServersHold.ScrollBarImageColor3 = PRIMARY_BLUE -- **สีฟ้าเท่ๆ**
	ServersHold.ScrollBarImageTransparency = 0.8 -- ทำให้จางลงเล็กน้อย
	ServersHold.CanvasSize = UDim2.new(0, 0, 0, 0)

	ServersHoldLayout.Name = "ServersHoldLayout"
	ServersHoldLayout.Parent = ServersHold
	ServersHoldLayout.SortOrder = Enum.SortOrder.LayoutOrder
	ServersHoldLayout.Padding = UDim.new(0, 7)

	ServersHoldPadding.Name = "ServersHoldPadding"
	ServersHoldPadding.Parent = ServersHold
	ServersHoldPadding.PaddingTop = UDim.new(0, 7)
	ServersHoldPadding.PaddingBottom = UDim.new(0, 7) -- เพิ่ม Padding บนล่าง

	CloseBtn.MouseButton1Click:Connect(
		function()
			MainFrame:TweenSize(UDim2.new(0, 0, 0, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, .3, true)
		end
	)

	CloseBtn.MouseEnter:Connect(
		function()
			CloseBtn.BackgroundColor3 = Color3.fromRGB(240, 71, 71) -- สีแดง
		end
	)

	CloseBtn.MouseLeave:Connect(
		function()
			CloseBtn.BackgroundColor3 = BACKGROUND_DARK
		end
	)

	MinimizeBtn.MouseEnter:Connect(
		function()
			MinimizeBtn.BackgroundColor3 = BACKGROUND_MID
		end
	)

	MinimizeBtn.MouseLeave:Connect(
		function()
			MinimizeBtn.BackgroundColor3 = BACKGROUND_DARK
		end
	)

	MinimizeBtn.MouseButton1Click:Connect(
		function()
			if minimized == false then
				MainFrame:TweenSize(
					UDim2.new(0, 681, 0, 22),
					Enum.EasingDirection.Out,
					Enum.EasingStyle.Quart,
					.3,
					true
				)
			else
				MainFrame:TweenSize(
					UDim2.new(0, 681, 0, 396),
					Enum.EasingDirection.Out,
					Enum.EasingStyle.Quart,
					.3,
					true
				)
			end
			minimized = not minimized
		end
	)
	
	local SettingsOpenBtn = Instance.new("TextButton")
	local SettingsOpenBtnIco = Instance.new("ImageLabel")
	
	SettingsOpenBtn.Name = "SettingsOpenBtn"
	SettingsOpenBtn.Parent = Userpad
	SettingsOpenBtn.BackgroundColor3 = PRIMARY_BLUE -- **สีฟ้าเท่ๆ**
	SettingsOpenBtn.BackgroundTransparency = 1.000
	SettingsOpenBtn.Position = UDim2.new(0.85, 0, 0.28, 0) -- ปรับตำแหน่ง
	SettingsOpenBtn.Size = UDim2.new(0, 18, 0, 18)
	SettingsOpenBtn.Font = Enum.Font.SourceSans
	SettingsOpenBtn.Text = ""
	SettingsOpenBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
	SettingsOpenBtn.TextSize = 14.000
	
	SettingsOpenBtn.MouseEnter:Connect(function()
		SettingsOpenBtnIco.ImageColor3 = PRIMARY_BLUE -- เปลี่ยนสีเมื่อวางเมาส์
	end)
	
	SettingsOpenBtn.MouseLeave:Connect(function()
		SettingsOpenBtnIco.ImageColor3 = TEXT_MUTED
	end)

	SettingsOpenBtnIco.Name = "SettingsOpenBtnIco"
	SettingsOpenBtnIco.Parent = SettingsOpenBtn
	SettingsOpenBtnIco.BackgroundColor3 = TEXT_LIGHT
	SettingsOpenBtnIco.BackgroundTransparency = 1.000
	SettingsOpenBtnIco.Size = UDim2.new(1, 0, 1, 0)
	SettingsOpenBtnIco.Image = "http://www.roblox.com/asset/?id=6031280882"
	SettingsOpenBtnIco.ImageColor3 = TEXT_MUTED -- เปลี่ยนสีไอคอน

	local SettingsFrame = Instance.new("Frame")
	local Settings = Instance.new("Frame")
	local SettingsHolder = Instance.new("Frame")
	local CloseSettingsBtn = Instance.new("TextButton")
	local CloseSettingsBtnCorner = Instance.new("UICorner")
	local CloseSettingsBtnCircle = Instance.new("Frame")
	local CloseSettingsBtnCircleCorner = Instance.new("UICorner")
	local CloseSettingsBtnIcon = Instance.new("ImageLabel")
	local TextLabel = Instance.new("TextLabel")
	local UserPanel = Instance.new("Frame")
	local UserSettingsPad = Instance.new("Frame")
	local UserSettingsPadCorner = Instance.new("UICorner")
	local UsernameText = Instance.new("TextLabel")
	local UserSettingsPadUserTag = Instance.new("Frame")
	local UserSettingsPadUser = Instance.new("TextLabel")
	local UserSettingsPadUserTagLayout = Instance.new("UIListLayout")
	local UserSettingsPadTag = Instance.new("TextLabel")
	local EditBtn = Instance.new("TextButton")
	local EditBtnCorner = Instance.new("UICorner")
	local UserPanelUserIcon = Instance.new("TextButton")
	local UserPanelUserImage = Instance.new("ImageLabel")
	local UserPanelUserCircle = Instance.new("ImageLabel")
	local BlackFrame = Instance.new("Frame")
	local BlackFrameCorner = Instance.new("UICorner")
	local ChangeAvatarText = Instance.new("TextLabel")
	local SearchIcoFrame = Instance.new("Frame")
	local SearchIcoFrameCorner = Instance.new("UICorner")
	local SearchIco = Instance.new("ImageLabel")
	local UserPanelUserTag = Instance.new("Frame")
	local UserPanelUser = Instance.new("TextLabel")
	local UserPanelUserTagLayout = Instance.new("UIListLayout")
	local UserPanelTag = Instance.new("TextLabel")
	local UserPanelCorner = Instance.new("UICorner")
	local LeftFrame = Instance.new("Frame")
	local MyAccountBtn = Instance.new("TextButton")
	local MyAccountBtnCorner = Instance.new("UICorner")
	local MyAccountBtnTitle = Instance.new("TextLabel")
	local SettingsTitle = Instance.new("TextLabel")
	local DiscordInfo = Instance.new("TextLabel")
	local CurrentSettingOpen = Instance.new("TextLabel")

	SettingsFrame.Name = "SettingsFrame"
	SettingsFrame.Parent = MainFrame
	SettingsFrame.BackgroundColor3 = BACKGROUND_MID
	SettingsFrame.BackgroundTransparency = 1.000
	SettingsFrame.Size = UDim2.new(1, 0, 1, 0)
	SettingsFrame.Visible = false

	Settings.Name = "Settings"
	Settings.Parent = SettingsFrame
	Settings.BackgroundColor3 = BACKGROUND_LIGHT -- สีที่สว่างขึ้น
	Settings.BorderSizePixel = 0
	Settings.Position = UDim2.new(0, 0, 0.053, 0)
	Settings.Size = UDim2.new(1, 0, 0.947, 0)

	SettingsHolder.Name = "SettingsHolder"
	SettingsHolder.Parent = Settings
	SettingsHolder.AnchorPoint = Vector2.new(0.5, 0.5)
	SettingsHolder.BackgroundColor3 = TEXT_LIGHT
	SettingsHolder.BackgroundTransparency = 1.000
	SettingsHolder.ClipsDescendants = true
	SettingsHolder.Position = UDim2.new(0.499, 0, 0.498, 0)
	SettingsHolder.Size = UDim2.new(0, 0, 0, 0)
	
	-- **Left Navigation Frame**
	LeftFrame.Name = "LeftFrame"
	LeftFrame.Parent = SettingsHolder
	LeftFrame.BackgroundColor3 = BACKGROUND_MID -- สีที่เข้มขึ้นเล็กน้อย
	LeftFrame.BorderSizePixel = 0
	LeftFrame.Size = UDim2.new(0, 218, 1, 0)
	LeftFrame.Position = UDim2.new(0, 0, 0, 0)

	SettingsTitle.Name = "SettingsTitle"
	SettingsTitle.Parent = LeftFrame
	SettingsTitle.BackgroundColor3 = TEXT_LIGHT
	SettingsTitle.BackgroundTransparency = 1.000
	SettingsTitle.Position = UDim2.new(0.09, 0, 0.05, 0)
	SettingsTitle.Size = UDim2.new(0, 150, 0, 20)
	SettingsTitle.Font = Enum.Font.GothamBold -- ฟอนต์เท่ๆ
	SettingsTitle.Text = "USER SETTINGS"
	SettingsTitle.TextColor3 = TEXT_MUTED
	SettingsTitle.TextSize = 13.000
	SettingsTitle.TextXAlignment = Enum.TextXAlignment.Left
	
	MyAccountBtn.Name = "MyAccountBtn"
	MyAccountBtn.Parent = LeftFrame
	MyAccountBtn.BackgroundColor3 = BACKGROUND_LIGHT
	MyAccountBtn.Position = UDim2.new(0.06, 0, 0.13, 0)
	MyAccountBtn.Size = UDim2.new(0, 185, 0, 28)
	MyAccountBtn.AutoButtonColor = false
	MyAccountBtn.Font = Enum.Font.GothamSemibold
	MyAccountBtn.Text = ""
	MyAccountBtn.TextColor3 = TEXT_LIGHT
	MyAccountBtn.TextSize = 14.000
	
	MyAccountBtnCorner.CornerRadius = UDim.new(0, 5)
	MyAccountBtnCorner.Name = "MyAccountBtnCorner"
	MyAccountBtnCorner.Parent = MyAccountBtn
	
	MyAccountBtnTitle.Name = "MyAccountBtnTitle"
	MyAccountBtnTitle.Parent = MyAccountBtn
	MyAccountBtnTitle.BackgroundColor3 = TEXT_LIGHT
	MyAccountBtnTitle.BackgroundTransparency = 1.000
	MyAccountBtnTitle.Size = UDim2.new(1, 0, 1, 0)
	MyAccountBtnTitle.Font = Enum.Font.GothamSemibold
	MyAccountBtnTitle.Text = "My Account"
	MyAccountBtnTitle.TextColor3 = TEXT_LIGHT
	MyAccountBtnTitle.TextSize = 14.000

	-- **User Panel**
	UserPanel.Name = "UserPanel"
	UserPanel.Parent = SettingsHolder
	UserPanel.BackgroundColor3 = BACKGROUND_MID -- สีที่เข้มขึ้น
	UserPanel.Position = UDim2.new(0.365, 0, 0.13, 0)
	UserPanel.Size = UDim2.new(0, 362, 0, 164)
	
	UserPanelCorner.CornerRadius = UDim.new(0, 5)
	UserPanelCorner.Name = "UserPanelCorner"
	UserPanelCorner.Parent = UserPanel

	UserSettingsPad.Name = "UserSettingsPad"
	UserSettingsPad.Parent = UserPanel
	UserSettingsPad.BackgroundColor3 = BACKGROUND_LIGHT
	UserSettingsPad.Position = UDim2.new(0.033, 0, 0.568, 0)
	UserSettingsPad.Size = UDim2.new(0, 337, 0, 56)

	UserSettingsPadCorner.CornerRadius = UDim.new(0, 5)
	UserSettingsPadCorner.Name = "UserSettingsPadCorner"
	UserSettingsPadCorner.Parent = UserSettingsPad

	UsernameText.Name = "UsernameText"
	UsernameText.Parent = UserSettingsPad
	UsernameText.BackgroundColor3 = TEXT_LIGHT
	UsernameText.BackgroundTransparency = 1.000
	UsernameText.Position = UDim2.new(0.042, 0, 0.15, 0)
	UsernameText.Size = UDim2.new(0, 65, 0, 19)
	UsernameText.Font = Enum.Font.GothamBold
	UsernameText.Text = "USERNAME"
	UsernameText.TextColor3 = Color3.fromRGB(126, 130, 136)
	UsernameText.TextSize = 11.000
	UsernameText.TextXAlignment = Enum.TextXAlignment.Left

	UserSettingsPadUserTag.Name = "UserSettingsPadUserTag"
	UserSettingsPadUserTag.Parent = UserSettingsPad
	UserSettingsPadUserTag.BackgroundColor3 = TEXT_LIGHT
	UserSettingsPadUserTag.BackgroundTransparency = 1.000
	UserSettingsPadUserTag.Position = UDim2.new(0.042, 0, 0.49, 0)
	UserSettingsPadUserTag.Size = UDim2.new(0, 150, 0, 19) -- กำหนดขนาดคงที่
	
	UserSettingsPadUser.Name = "UserSettingsPadUser"
	UserSettingsPadUser.Parent = UserSettingsPadUserTag
	UserSettingsPadUser.BackgroundColor3 = TEXT_LIGHT
	UserSettingsPadUser.BackgroundTransparency = 1.000
	UserSettingsPadUser.Font = Enum.Font.Gotham
	UserSettingsPadUser.TextColor3 = TEXT_LIGHT
	UserSettingsPadUser.TextSize = 13.000
	UserSettingsPadUser.TextXAlignment = Enum.TextXAlignment.Left
	UserSettingsPadUser.Text = user
	UserSettingsPadUser.Size = UDim2.new(1, 0, 1, 0) -- บั๊ก: ไม่ใช้ TextBounds.X ในกรณีนี้
	
	UserSettingsPadUserTagLayout.Name = "UserSettingsPadUserTagLayout"
	UserSettingsPadUserTagLayout.Parent = UserSettingsPadUserTag
	UserSettingsPadUserTagLayout.FillDirection = Enum.FillDirection.Horizontal
	UserSettingsPadUserTagLayout.SortOrder = Enum.SortOrder.LayoutOrder

	UserSettingsPadTag.Name = "UserSettingsPadTag"
	UserSettingsPadTag.Parent = UserSettingsPadUserTag
	UserSettingsPadTag.BackgroundColor3 = TEXT_LIGHT
	UserSettingsPadTag.BackgroundTransparency = 1.000
	UserSettingsPadTag.Position = UDim2.new(0.042, 0, 0.49, 0)
	UserSettingsPadTag.Size = UDim2.new(0, 65, 0, 19)
	UserSettingsPadTag.Font = Enum.Font.Gotham
	UserSettingsPadTag.Text = "#" .. tag
	UserSettingsPadTag.TextColor3 = TEXT_MUTED
	UserSettingsPadTag.TextSize = 13.000
	UserSettingsPadTag.TextXAlignment = Enum.TextXAlignment.Left

	EditBtn.Name = "EditBtn"
	EditBtn.Parent = UserSettingsPad
	EditBtn.BackgroundColor3 = PRIMARY_BLUE -- **สีฟ้าเท่ๆ**
	EditBtn.Position = UDim2.new(0.797, 0, 0.23, 0)
	EditBtn.Size = UDim2.new(0, 55, 0, 30)
	EditBtn.Font = Enum.Font.Gotham
	EditBtn.Text = "Edit"
	EditBtn.TextColor3 = TEXT_LIGHT
	EditBtn.TextSize = 14.000
	EditBtn.AutoButtonColor = false
	
	EditBtn.MouseEnter:Connect(function()
		TweenService:Create(
			EditBtn,
			TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
			{BackgroundColor3 = BUTTON_HOVER} -- สีฟ้าเข้มขึ้น
		):Play()
	end)
	
	EditBtn.MouseLeave:Connect(function()
		TweenService:Create(
			EditBtn,
			TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
			{BackgroundColor3 = PRIMARY_BLUE}
		):Play()
	end)

	EditBtnCorner.CornerRadius = UDim.new(0, 3)
	EditBtnCorner.Name = "EditBtnCorner"
	EditBtnCorner.Parent = EditBtn

	UserPanelUserIcon.Name = "UserPanelUserIcon"
	UserPanelUserIcon.Parent = UserPanel
	UserPanelUserIcon.BackgroundColor3 = BACKGROUND_DARK
	UserPanelUserIcon.BorderSizePixel = 0
	UserPanelUserIcon.Position = UDim2.new(0.034, 0, 0.074, 0)
	UserPanelUserIcon.Size = UDim2.new(0, 71, 0, 71)
	UserPanelUserIcon.AutoButtonColor = false
	UserPanelUserIcon.Text = ""

	UserPanelUserImage.Name = "UserPanelUserImage"
	UserPanelUserImage.Parent = UserPanelUserIcon
	UserPanelUserImage.BackgroundColor3 = TEXT_LIGHT
	UserPanelUserImage.BackgroundTransparency = 1.000
	UserPanelUserImage.Size = UDim2.new(1, 0, 1, 0)
	UserPanelUserImage.Image = pfp

	UserPanelUserCircle.Name = "UserPanelUserCircle"
	UserPanelUserCircle.Parent = UserPanelUserImage
	UserPanelUserCircle.BackgroundColor3 = TEXT_LIGHT
	UserPanelUserCircle.BackgroundTransparency = 1.000
	UserPanelUserCircle.Size = UDim2.new(1, 0, 1, 0)
	UserPanelUserCircle.Image = "rbxassetid://4031889928"
	UserPanelUserCircle.ImageColor3 = BACKGROUND_MID

	BlackFrame.Name = "BlackFrame"
	BlackFrame.Parent = UserPanelUserIcon
	BlackFrame.BackgroundColor3 = PRIMARY_BLUE -- **เปลี่ยนเป็นสีฟ้าเท่ๆ**
	BlackFrame.BackgroundTransparency = 0.6 -- เพิ่มความโปร่งใสเล็กน้อย
	BlackFrame.BorderSizePixel = 0
	BlackFrame.Size = UDim2.new(1, 0, 1, 0)
	BlackFrame.Visible = false

	BlackFrameCorner.CornerRadius = UDim.new(1, 8)
	BlackFrameCorner.Name = "BlackFrameCorner"
	BlackFrameCorner.Parent = BlackFrame

	ChangeAvatarText.Name = "ChangeAvatarText"
	ChangeAvatarText.Parent = BlackFrame
	ChangeAvatarText.BackgroundColor3 = TEXT_LIGHT
	ChangeAvatarText.BackgroundTransparency = 1.000
	ChangeAvatarText.Size = UDim2.new(1, 0, 1, 0)
	ChangeAvatarText.Font = Enum.Font.GothamBold
	ChangeAvatarText.Text = "CHANGE AVATAR"
	ChangeAvatarText.TextColor3 = TEXT_LIGHT
	ChangeAvatarText.TextSize = 11.000
	ChangeAvatarText.TextWrapped = true

	SearchIcoFrame.Name = "SearchIcoFrame"
	SearchIcoFrame.Parent = UserPanelUserIcon
	SearchIcoFrame.BackgroundColor3 = PRIMARY_BLUE -- **สีฟ้าเท่ๆ**
	SearchIcoFrame.Position = UDim2.new(0.65, 0, 0, 0)
	SearchIcoFrame.Size = UDim2.new(0, 20, 0, 20)

	SearchIcoFrameCorner.CornerRadius = UDim.new(1, 8)
	SearchIcoFrameCorner.Name = "SearchIcoFrameCorner"
	SearchIcoFrameCorner.Parent = SearchIcoFrame

	SearchIco.Name = "SearchIco"
	SearchIco.Parent = SearchIcoFrame
	SearchIco.BackgroundColor3 = TEXT_LIGHT
	SearchIco.BackgroundTransparency = 1.000
	SearchIco.Position = UDim2.new(0.15, 0, 0.1, 0)
	SearchIco.Size = UDim2.new(0, 15, 0, 15)
	SearchIco.Image = "http://www.roblox.com/asset/?id=6034407084"
	SearchIco.ImageColor3 = TEXT_LIGHT -- เปลี่ยนเป็นสีขาว
	
	-- ส่วนที่เหลือของ UserPanelUserTag (ไม่ต้องเปลี่ยนมาก)
	UserPanelUserTag.Name = "UserPanelUserTag"
	UserPanelUserTag.Parent = UserPanel
	UserPanelUserTag.BackgroundColor3 = TEXT_LIGHT
	UserPanelUserTag.BackgroundTransparency = 1.000
	UserPanelUserTag.Position = UDim2.new(0.297, 0, 0.28, 0)
	UserPanelUserTag.Size = UDim2.new(0, 150, 0, 19)

	UserPanelUser.Name = "UserPanelUser"
	UserPanelUser.Parent = UserPanelUserTag
	UserPanelUser.BackgroundColor3 = TEXT_LIGHT
	UserPanelUser.BackgroundTransparency = 1.000
	UserPanelUser.Font = Enum.Font.GothamSemibold
	UserPanelUser.TextColor3 = TEXT_LIGHT
	UserPanelUser.TextSize = 16.000
	UserPanelUser.TextXAlignment = Enum.TextXAlignment.Left
	UserPanelUser.Text = user
	UserPanelUser.Size = UDim2.new(1, 0, 1, 0) -- บั๊ก: ไม่ใช้ TextBounds.X

	UserPanelUserTagLayout.Name = "UserPanelUserTagLayout"
	UserPanelUserTagLayout.Parent = UserPanelUserTag
	UserPanelUserTagLayout.FillDirection = Enum.FillDirection.Horizontal
	UserPanelUserTagLayout.SortOrder = Enum.SortOrder.LayoutOrder

	UserPanelTag.Name = "UserPanelTag"
	UserPanelTag.Parent = UserPanelUserTag
	UserPanelTag.BackgroundColor3 = TEXT_LIGHT
	UserPanelTag.BackgroundTransparency = 1.000
	UserPanelTag.Size = UDim2.new(0, 65, 0, 19)
	UserPanelTag.Font = Enum.Font.Gotham
	UserPanelTag.Text = "#" .. tag
	UserPanelTag.TextColor3 = TEXT_MUTED
	UserPanelTag.TextSize = 14.000
	UserPanelTag.TextXAlignment = Enum.TextXAlignment.Left

	
	UserPanelUserIcon.MouseEnter:Connect(function()
		BlackFrame.Visible = true
	end)
	
	UserPanelUserIcon.MouseLeave:Connect(function()
		BlackFrame.Visible = false
	end)
	
	SettingsOpenBtn.MouseButton1Click:Connect(function()
		settingsopened = true
		TopFrameHolder.Visible = false
		ServersHoldFrame.Visible = false
		SettingsFrame.Visible = true
		SettingsHolder:TweenSize(UDim2.new(0, 620, 0, 315), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, .3, true)
		TweenService:Create(
			Settings,
			TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
			{BackgroundTransparency = 0}
		):Play()
		for i,v in next, SettingsHolder:GetChildren() do
			TweenService:Create(
				v,
				TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
				{BackgroundTransparency = 0}
			):Play()
		end
		-- ตำแหน่ง LeftFrame และ UserPanel
		LeftFrame.Position = UDim2.new(0, 0, 0, 0)
		UserPanel.Position = UDim2.new(0.365, 0, 0.13, 0)
		
		-- ทำให้ MyAccountBtn เป็นสีน้ำเงินเมื่อเปิด Settings
		TweenService:Create(
			MyAccountBtn,
			TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
			{BackgroundColor3 = PRIMARY_BLUE}
		):Play()
	end)

	CloseSettingsBtn.Name = "CloseSettingsBtn"
	CloseSettingsBtn.Parent = SettingsHolder
	CloseSettingsBtn.AnchorPoint = Vector2.new(0.5, 0.5)
	CloseSettingsBtn.BackgroundColor3 = BACKGROUND_MID
	CloseSettingsBtn.Position = UDim2.new(0.952, 0, 0.085, 0)
	CloseSettingsBtn.Selectable = false
	CloseSettingsBtn.Size = UDim2.new(0, 30, 0, 30)
	CloseSettingsBtn.AutoButtonColor = false
	CloseSettingsBtn.Font = Enum.Font.SourceSans
	CloseSettingsBtn.Text = ""
	CloseSettingsBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
	CloseSettingsBtn.TextSize = 14.000

	CloseSettingsBtnCorner.CornerRadius = UDim.new(1, 0)
	CloseSettingsBtnCorner.Name = "CloseSettingsBtnCorner"
	CloseSettingsBtnCorner.Parent = CloseSettingsBtn

	CloseSettingsBtnCircle.Name = "CloseSettingsBtnCircle"
	CloseSettingsBtnCircle.Parent = CloseSettingsBtn
	CloseSettingsBtnCircle.BackgroundColor3 = BACKGROUND_LIGHT
	CloseSettingsBtnCircle.Position = UDim2.new(0.087, 0, 0.118, 0)
	CloseSettingsBtnCircle.Size = UDim2.new(0, 24, 0, 24)

	CloseSettingsBtnCircleCorner.CornerRadius = UDim.new(1, 0)
	CloseSettingsBtnCircleCorner.Name = "CloseSettingsBtnCircleCorner"
	CloseSettingsBtnCircleCorner.Parent = CloseSettingsBtnCircle

	CloseSettingsBtnIcon.Name = "CloseSettingsBtnIcon"
	CloseSettingsBtnIcon.Parent = CloseSettingsBtnCircle
	CloseSettingsBtnIcon.BackgroundColor3 = TEXT_LIGHT
	CloseSettingsBtnIcon.BackgroundTransparency = 1.000
	CloseSettingsBtnIcon.Position = UDim2.new(0, 2, 0, 2)
	CloseSettingsBtnIcon.Size = UDim2.new(0, 19, 0, 19)
	CloseSettingsBtnIcon.Image = "http://www.roblox.com/asset/?id=6035047409"
	CloseSettingsBtnIcon.ImageColor3 = TEXT_MUTED
	
	CloseSettingsBtn.MouseButton1Click:Connect(function()
		settingsopened = false
		TopFrameHolder.Visible = true
		ServersHoldFrame.Visible = true
		SettingsHolder:TweenSize(UDim2.new(0, 0, 0, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, .3, true)
		TweenService:Create(
			Settings,
			TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
			{BackgroundTransparency = 1}
		):Play()
		for i,v in next, SettingsHolder:GetChildren() do
			TweenService:Create(
				v,
				TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
				{BackgroundTransparency = 1}
			):Play()
		end
		wait(.3)
		SettingsFrame.Visible = false
	end)
	
	CloseSettingsBtn.MouseEnter:Connect(function()
		CloseSettingsBtnCircle.BackgroundColor3 = Color3.fromRGB(72,76,82)
	end)

	CloseSettingsBtn.MouseLeave:Connect(function()
		CloseSettingsBtnCircle.BackgroundColor3 = BACKGROUND_LIGHT
	end)
	
	UserInputService.InputBegan:Connect(
		function(io, p)
			if io.KeyCode == Enum.KeyCode.RightControl then
				if settingsopened == true then
					settingsopened = false
					TopFrameHolder.Visible = true
					ServersHoldFrame.Visible = true
					SettingsHolder:TweenSize(UDim2.new(0, 0, 0, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, .3, true)
					TweenService:Create(
						Settings,
						TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
						{BackgroundTransparency = 1}
					):Play()
					for i,v in next, SettingsHolder:GetChildren() do
						TweenService:Create(
							v,
							TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
							{BackgroundTransparency = 1}
						):Play()
					end
					wait(.3)
					SettingsFrame.Visible = false
				end
			end
		end
	)

	TextLabel.Parent = CloseSettingsBtn
	TextLabel.BackgroundColor3 = TEXT_LIGHT
	TextLabel.BackgroundTransparency = 1.000
	TextLabel.Position = UDim2.new(-0.066, 0, 1.06, 0)
	TextLabel.Size = UDim2.new(0, 34, 0, 22)
	TextLabel.Font = Enum.Font.GothamSemibold
	TextLabel.Text = "rightctrl"
	TextLabel.TextColor3 = Color3.fromRGB(113, 117, 123)
	TextLabel.TextSize = 11.000

	UserPanelUserIcon.MouseButton1Click:Connect(function()
		local NotificationHolder = Instance.new("TextButton")
		NotificationHolder.Name = "NotificationHolder"
		NotificationHolder.Parent = SettingsHolder
		NotificationHolder.BackgroundColor3 = BACKGROUND_DARK
		NotificationHolder.Position = UDim2.new(0, 0, 0, 0) -- แก้ไขตำแหน่งให้เต็ม SettingsHolder
		NotificationHolder.Size = UDim2.new(1, 0, 1, 0) -- แก้ไขขนาดให้เต็ม SettingsHolder
		NotificationHolder.AutoButtonColor = false
		NotificationHolder.Font = Enum.Font.SourceSans
		NotificationHolder.Text = ""
		NotificationHolder.TextColor3 = Color3.fromRGB(0, 0, 0)
		NotificationHolder.TextSize = 14.000
		NotificationHolder.BackgroundTransparency = 1
		NotificationHolder.Visible = true
		TweenService:Create(
			NotificationHolder,
			TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
			{BackgroundTransparency = 0.5} -- เปลี่ยนเป็น 0.5 ให้มองเห็นพื้นหลัง
		):Play()


		local AvatarChange = Instance.new("Frame")
		local UserChangeCorner = Instance.new("UICorner")
		local UnderBar = Instance.new("Frame")
		local UnderBarCorner = Instance.new("UICorner")
		local UnderBarFrame = Instance.new("Frame")
		local Text1 = Instance.new("TextLabel")
		local Text2 = Instance.new("TextLabel")
		local TextBoxFrame = Instance.new("Frame")
		local TextBoxFrameCorner = Instance.new("UICorner")
		local TextBoxFrame1 = Instance.new("Frame")
		local TextBoxFrame1Corner = Instance.new("UICorner")
		local AvatarTextbox = Instance.new("TextBox")
		local ChangeBtn = Instance.new("TextButton")
		local ChangeCorner = Instance.new("UICorner")
		local CloseBtn2 = Instance.new("TextButton")
		local Close2Icon = Instance.new("ImageLabel")
		local CloseBtn1 = Instance.new("TextButton")
		local CloseBtn1Corner = Instance.new("UICorner")
		local ResetBtn = Instance.new("TextButton")
		local ResetCorner = Instance.new("UICorner")


		AvatarChange.Name = "AvatarChange"
		AvatarChange.Parent = NotificationHolder
		AvatarChange.AnchorPoint = Vector2.new(0.5, 0.5)
		AvatarChange.BackgroundColor3 = BACKGROUND_LIGHT
		AvatarChange.ClipsDescendants = true
		AvatarChange.Position = UDim2.new(0.5, 0, 0.5, 0)
		AvatarChange.Size = UDim2.new(0, 0, 0, 0)
		AvatarChange.BackgroundTransparency = 1
		
		AvatarChange:TweenSize(UDim2.new(0, 346, 0, 198), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, .2, true)
		TweenService:Create(
			AvatarChange,
			TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
			{BackgroundTransparency = 0}
		):Play()


		UserChangeCorner.CornerRadius = UDim.new(0, 5)
		UserChangeCorner.Name = "UserChangeCorner"
		UserChangeCorner.Parent = AvatarChange

		UnderBar.Name = "UnderBar"
		UnderBar.Parent = AvatarChange
		UnderBar.BackgroundColor3 = BACKGROUND_MID
		UnderBar.Position = UDim2.new(0, 0, 0.81, 0) -- แก้ไขตำแหน่งให้ครอบคลุมส่วนล่าง
		UnderBar.Size = UDim2.new(1, 0, 0.19, 0)

		UnderBarCorner.CornerRadius = UDim.new(0, 0) -- ไม่ต้องมีมุมโค้ง
		UnderBarCorner.Name = "UnderBarCorner"
		UnderBarCorner.Parent = UnderBar
		
		UnderBarFrame.Name = "UnderBarFrame"
		UnderBarFrame.Parent = UnderBar
		UnderBarFrame.BackgroundColor3 = BACKGROUND_MID
		UnderBarFrame.BorderSizePixel = 0
		UnderBarFrame.Position = UDim2.new(0, 0, 0, 0)
		UnderBarFrame.Size = UDim2.new(1, 0, 1, 0)

		Text1.Name = "Text1"
		Text1.Parent = AvatarChange
		Text1.BackgroundColor3 = TEXT_LIGHT
		Text1.BackgroundTransparency = 1.000
		Text1.Position = UDim2.new(0.04, 0, 0.04, 0)
		Text1.Size = UDim2.new(0, 318, 0, 30)
		Text1.Font = Enum.Font.GothamBold
		Text1.Text = "Change your avatar"
		Text1.TextColor3 = TEXT_LIGHT
		Text1.TextSize = 20.000
		Text1.TextXAlignment = Enum.TextXAlignment.Left

		Text2.Name = "Text2"
		Text2.Parent = AvatarChange
		Text2.BackgroundColor3 = TEXT_LIGHT
		Text2.BackgroundTransparency = 1.000
		Text2.Position = UDim2.new(0.04, 0, 0.18, 0)
		Text2.Size = UDim2.new(0, 318, 0, 20)
		Text2.Font = Enum.Font.Gotham
		Text2.Text = "Enter your new profile in a Roblox decal link."
		Text2.TextColor3 = TEXT_MUTED
		Text2.TextSize = 14.000
		Text2.TextXAlignment = Enum.TextXAlignment.Left

		TextBoxFrame.Name = "TextBoxFrame"
		TextBoxFrame.Parent = AvatarChange
		TextBoxFrame.AnchorPoint = Vector2.new(0.5, 0.5)
		TextBoxFrame.BackgroundColor3 = Color3.fromRGB(37, 40, 43)
		TextBoxFrame.Position = UDim2.new(0.5, 0, 0.55, 0)
		TextBoxFrame.Size = UDim2.new(0, 319, 0, 38)

		TextBoxFrameCorner.CornerRadius = UDim.new(0, 3)
		TextBoxFrameCorner.Name = "TextBoxFrameCorner"
		TextBoxFrameCorner.Parent = TextBoxFrame

		TextBoxFrame1.Name = "TextBoxFrame1"
		TextBoxFrame1.Parent = TextBoxFrame
		TextBoxFrame1.AnchorPoint = Vector2.new(0.5, 0.5)
		TextBoxFrame1.BackgroundColor3 = BACKGROUND_MID
		TextBoxFrame1.ClipsDescendants = true
		TextBoxFrame1.Position = UDim2.new(0.5, 0, 0.5, 0)
		TextBoxFrame1.Size = UDim2.new(0, 317, 0, 36)

		TextBoxFrame1Corner.CornerRadius = UDim.new(0, 3)
		TextBoxFrame1Corner.Name = "TextBoxFrame1Corner"
		TextBoxFrame1Corner.Parent = TextBoxFrame1

		AvatarTextbox.Name = "AvatarTextbox"
		AvatarTextbox.Parent = TextBoxFrame1
		AvatarTextbox.BackgroundColor3 = TEXT_LIGHT
		AvatarTextbox.BackgroundTransparency = 1.000
		AvatarTextbox.Position = UDim2.new(0.03, 0, 0, 0)
		AvatarTextbox.Size = UDim2.new(0, 293, 0, 37)
		AvatarTextbox.Font = Enum.Font.Gotham
		AvatarTextbox.Text = ""
		AvatarTextbox.TextColor3 = TEXT_MUTED
		AvatarTextbox.TextSize = 14.000
		AvatarTextbox.TextXAlignment = Enum.TextXAlignment.Left

		ChangeBtn.Name = "ChangeBtn"
		ChangeBtn.Parent = UnderBar
		ChangeBtn.BackgroundColor3 = PRIMARY_BLUE
		ChangeBtn.Position = UDim2.new(0.75, 0, 0.15, 0)
		ChangeBtn.Size = UDim2.new(0, 76, 0, 27)
		ChangeBtn.Font = Enum.Font.Gotham
		ChangeBtn.Text = "Change"
		ChangeBtn.TextColor3 = TEXT_LIGHT
		ChangeBtn.TextSize = 13.000
		ChangeBtn.AutoButtonColor = false

		ChangeBtn.MouseEnter:Connect(function()
			TweenService:Create(
				ChangeBtn,
				TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
				{BackgroundColor3 = BUTTON_HOVER}
			):Play()
		end)

		ChangeBtn.MouseLeave:Connect(function()
			TweenService:Create(
				ChangeBtn,
				TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
				{BackgroundColor3 = PRIMARY_BLUE}
			):Play()
		end)

		ChangeBtn.MouseButton1Click:Connect(function()
			pfp = tostring(AvatarTextbox.Text)
			UserImage.Image = pfp 
			UserPanelUserImage.Image = pfp
			SaveInfo()
			
			NotificationHolder:TweenSize(UDim2.new(0, 0, 0, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, .2, true)
			TweenService:Create(
				NotificationHolder,
				TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
				{BackgroundTransparency = 1}
			):Play()
			wait(.2)
			NotificationHolder:Destroy()
		end)

		ChangeCorner.CornerRadius = UDim.new(0, 3)
		ChangeCorner.Name = "ChangeCorner"
		ChangeCorner.Parent = ChangeBtn

		CloseBtn1.Name = "CloseBtn1"
		CloseBtn1.Parent = UnderBar
		CloseBtn1.BackgroundColor3 = BACKGROUND_MID
		CloseBtn1.Position = UDim2.new(0.53, 0, 0.15, 0)
		CloseBtn1.Size = UDim2.new(0, 76, 0, 27)
		CloseBtn1.Font = Enum.Font.Gotham
		CloseBtn1.Text = "Cancel"
		CloseBtn1.TextColor3 = TEXT_LIGHT
		CloseBtn1.TextSize = 13.000
		CloseBtn1.AutoButtonColor = false
		
		CloseBtn1.MouseEnter:Connect(function()
			CloseBtn1.BackgroundTransparency = 0.5
		end)
		
		CloseBtn1.MouseLeave:Connect(function()
			CloseBtn1.BackgroundTransparency = 0
		end)

		CloseBtn1.MouseButton1Click:Connect(function()
			NotificationHolder:TweenSize(UDim2.new(0, 0, 0, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, .2, true)
			TweenService:Create(
				NotificationHolder,
				TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
				{BackgroundTransparency = 1}
			):Play()
			wait(.2)
			NotificationHolder:Destroy()
		end)

		CloseBtn1Corner.CornerRadius = UDim.new(0, 3)
		CloseBtn1Corner.Name = "CloseBtn1Corner"
		CloseBtn1Corner.Parent = CloseBtn1
		
		ResetBtn.Name = "ResetBtn"
		ResetBtn.Parent = UnderBar
		ResetBtn.BackgroundColor3 = Color3.fromRGB(240, 71, 71)
		ResetBtn.Position = UDim2.new(0.04, 0, 0.15, 0)
		ResetBtn.Size = UDim2.new(0, 76, 0, 27)
		ResetBtn.Font = Enum.Font.Gotham
		ResetBtn.Text = "Reset"
		ResetBtn.TextColor3 = TEXT_LIGHT
		ResetBtn.TextSize = 13.000
		ResetBtn.AutoButtonColor = false
		
		ResetBtn.MouseEnter:Connect(function()
			TweenService:Create(
				ResetBtn,
				TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
				{BackgroundColor3 = Color3.fromRGB(220, 50, 50)}
			):Play()
		end)

		ResetBtn.MouseLeave:Connect(function()
			TweenService:Create(
				ResetBtn,
				TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
				{BackgroundColor3 = Color3.fromRGB(240, 71, 71)}
			):Play()
		end)

		ResetBtn.MouseButton1Click:Connect(function()
			pfp = "https://www.roblox.com/headshot-thumbnail/image?userId=".. game.Players.LocalPlayer.UserId .."&width=420&height=420&format=png"
			UserImage.Image = pfp 
			UserPanelUserImage.Image = pfp
			SaveInfo()
			
			NotificationHolder:TweenSize(UDim2.new(0, 0, 0, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, .2, true)
			TweenService:Create(
				NotificationHolder,
				TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
				{BackgroundTransparency = 1}
			):Play()
			wait(.2)
			NotificationHolder:Destroy()
		end)

		ResetCorner.CornerRadius = UDim.new(0, 3)
		ResetCorner.Name = "ResetCorner"
		ResetCorner.Parent = ResetBtn
	end)

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
			
			ServerBtn.MouseEnter:Connect(function()
				if currentservertoggled ~= text then
					TweenService:Create(
						ServerBtn,
						TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
						{BackgroundColor3 = PRIMARY_BLUE}
					):Play()
					ServerBtnCorner.CornerRadius = UDim.new(0, 16)
				end
			end)
			
			ServerBtn.MouseLeave:Connect(function()
				if currentservertoggled ~= text then
					TweenService:Create(
						ServerBtn,
						TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
						{BackgroundColor3 = BACKGROUND_DARK}
					):Play()
					ServerBtnCorner.CornerRadius = UDim.new(1, 0)
				end
			end)
			
			ServerBtn.MouseButton1Click:Connect(function()
				if currentservertoggled == text then
					-- ทำการยกเลิกการเลือก
					currentservertoggled = ""
					ServerBtnCorner.CornerRadius = UDim.new(1, 0)
					TweenService:Create(
						ServerBtn,
						TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
						{BackgroundColor3 = BACKGROUND_DARK}
					):Play()
					TweenService:Create(
						ServerBtnIndicator,
						TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
						{Size = UDim2.new(0, 0, 0, 0)}
					):Play()
				else
					-- ยกเลิกการเลือกเซิร์ฟเวอร์เก่า
					for i, v in pairs(ServersHold:GetChildren()) do
						if v:IsA("ImageButton") and v.Name == currentservertoggled then
							v.UICorner.CornerRadius = UDim.new(1, 0)
							TweenService:Create(
								v,
								TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
								{BackgroundColor3 = BACKGROUND_DARK}
							):Play()
							v.ServerBtnIndicator.Size = UDim2.new(0, 0, 0, 0)
						end
					end
					
					-- เลือกเซิร์ฟเวอร์ใหม่
					currentservertoggled = text
					ServerBtnCorner.CornerRadius = UDim.new(0, 16)
					TweenService:Create(
						ServerBtn,
						TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
						{BackgroundColor3 = PRIMARY_BLUE}
					):Play()
					TweenService:Create(
						ServerBtnIndicator,
						TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
						{Size = UDim2.new(0, 4, 0, 30)}
					):Play()
				end
			end)

			ServerBtnCorner.CornerRadius = UDim.new(1, 0)
			ServerBtnCorner.Name = "ServerBtnCorner"
			ServerBtnCorner.Parent = ServerBtn
			
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
		SettingsFrame = SettingsHolder,
		ServersHoldFrame = ServersHoldFrame
	}
end

return DiscordLib
