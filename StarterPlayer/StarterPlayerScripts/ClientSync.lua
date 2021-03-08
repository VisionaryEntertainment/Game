local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remoteEvent = ReplicatedStorage:WaitForChild("RemoteSync")
local RemoteAnimEvent = ReplicatedStorage:WaitForChild("PlayerAnimation")
local player = game:GetService("Players").LocalPlayer
local humLoad

event = remoteEvent.OnClientEvent:Connect(function(stop, id, time)
	local character = player.Character or player.CharacterAdded:Wait()
	local humanoid = character:WaitForChild("Humanoid")
	if stop == false then
		remoteEvent:FireServer(true)
		local animation = script.Animation
		animation.AnimationId = id
		humLoad = humanoid:LoadAnimation(animation)
		humLoad:Play()
		humLoad.TimePosition = time
	elseif stop == true then
		remoteEvent:FireServer(false)
		local AnimationTracks = humanoid:GetPlayingAnimationTracks()
		for i, track in pairs (AnimationTracks) do
			track:Stop()
		end
	end
end)
