-- written and tested by github.com/xspyy
-- GAME: MURDER MYSTERY 2 - PLACEID: 142823291

local p=game.Players.LocalPlayer
local pads=workspace.RegularLobby.VotePads
local detectors={Detector1=pads.Detector1,Detector2=pads.Detector2,Detector3=pads.Detector3}

local selecteddetector,enabled,teleportloop

local gui=Instance.new("ScreenGui",game.CoreGui)
gui.Name="xspylol"
gui.ResetOnSpawn=false

local frame=Instance.new("Frame",gui)
frame.Size=UDim2.new(0,250,0,240)
frame.Position=UDim2.new(.05,0,.3,0)
frame.BackgroundColor3=Color3.fromRGB(35,35,35)

-- mobile drag
local drag=false,dragstart,startpos
frame.InputBegan:Connect(function(i)
	if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
		drag=true
		dragstart=i.Position
		startpos=frame.Position
	end
end)

frame.InputChanged:Connect(function(i)
	if drag and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
		local d=i.Position-dragstart
		frame.Position=UDim2.new(startpos.X.Scale,startpos.X.Offset+d.X,startpos.Y.Scale,startpos.Y.Offset+d.Y)
	end
end)

game:GetService("UserInputService").InputEnded:Connect(function(i)
	if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then drag=false end
end)


local title=Instance.new("TextLabel",frame)
title.Size=UDim2.new(1,0,0,40)
title.Text="MM2 AUTO VOTE"
title.TextScaled=true
title.BackgroundTransparency=1
title.TextColor3=Color3.new(1,1,1)

-- we give credits to the grand xspy, heh..
local credits=Instance.new("TextLabel",frame)
credits.Size=UDim2.new(1,0,0,20)
credits.Position=UDim2.new(0,0,0,35)
credits.Text="github.com/xspyy"
credits.TextScaled=true
credits.BackgroundTransparency=1
credits.TextColor3=Color3.fromRGB(170,170,170)


local function tp()
	local c=p.Character
	local hrp=c and c:FindFirstChild("HumanoidRootPart")
	if hrp and selecteddetector then
		hrp.CFrame=selecteddetector.CFrame+Vector3.new(0,3,0)
	end
end


local y=65
for name,part in detectors do
	local b=Instance.new("TextButton",frame)
	b.Size=UDim2.new(.8,0,0,35)
	b.Position=UDim2.new(.1,0,0,y)
	b.Text=name
	b.TextScaled=true
	
	b.MouseButton1Click:Connect(function()
		selecteddetector=part
		for _,v in frame:GetChildren() do
			if v:IsA("TextButton") then v.BackgroundColor3=Color3.new(1,1,1) end
		end
		b.BackgroundColor3=Color3.new(0,1,0)
	end)
	y+=40
end


local toggle=Instance.new("TextButton",frame)
toggle.Size=UDim2.new(.8,0,0,35)
toggle.Position=UDim2.new(.1,0,0,195)
toggle.Text="OFF"
toggle.TextScaled=true

toggle.MouseButton1Click:Connect(function()
	if not selecteddetector then toggle.Text="SELECT";task.wait(1);toggle.Text="OFF";return end
	
	enabled=not enabled
	toggle.Text=enabled and "ON" or "OFF"

	if enabled then
		teleportloop=task.spawn(function()
			while enabled do
				tp()
				local h=p.Character and p.Character:FindFirstChildOfClass("Humanoid")
				if h then h.Health=0 end
				p.CharacterAdded:Wait()
				task.wait(.2)
				tp()
				task.wait(1)
			end
		end)
	elseif teleportloop then
		task.cancel(teleportloop)
	end
end)
