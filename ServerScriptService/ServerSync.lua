
local syncthing = "/sync ([%w_]+)"
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remoteevent = ReplicatedStorage:WaitForChild("RemoteSync")
local RemoteAnimEvent = ReplicatedStorage:WaitForChild("PlayerAnimation")

game.Players.PlayerAdded:Connect(function(player)
	local currentanimation = Instance.new("StringValue")
	currentanimation.Parent = player
	currentanimation.Name = "CurrentAnimation"
	currentanimation.Value = 0
	local isplaying = Instance.new("BoolValue")
	isplaying.Parent = currentanimation
	isplaying.Name = "IsPlaying"
	isplaying.Value = false
	local sync = false
	player.Chatted:Connect(function(msg)
		local subjectName = msg:match(syncthing)
		if msg == "/sync" or msg == "/desync" then
			remoteevent:FireClient(player, true)
			sync = false
		end
		if subjectName and sync == false then
			for i, plr in pairs(Players:GetPlayers()) do

				if subjectName:lower() == (plr.Name:lower()):sub(1, #subjectName) then
					if plr == player then break end
					sync = true
					local prevtrack
					local subjectanimation = plr:WaitForChild("CurrentAnimation")
					local subplaying = subjectanimation:WaitForChild("IsPlaying")
					while sync == true do
						local subhumanoid = plr.Character:WaitForChild("Humanoid")
						local humanoid = player.Character:WaitForChild("Humanoid")
						if subhumanoid.Health <= 0 or humanoid.Health <= 0 then
							sync = false
							remoteevent:FireClient(player, true)
							break
						end
						if prevtrack ~= subjectanimation.Value then
							prevtrack = subjectanimation.Value
							if subplaying.Value == true then
								local AnimationTracks = subhumanoid:GetPlayingAnimationTracks()
								for i, track in pairs (AnimationTracks) do
									if track.Priority == Enum.AnimationPriority.Action then
										remoteevent:FireClient(player, false, track.Animation.AnimationId, track.TimePosition)
									end
								end
							end	
							if subplaying.Value == false then
								remoteevent:FireClient(player, true)
							end
						end
						wait()
					end
				end
			end
		end
	end)
end)

RemoteAnimEvent.OnServerEvent:Connect(function(player, playing)
	local currentanimation = player:WaitForChild("CurrentAnimation")
	currentanimation.Value = currentanimation.Value + 1
	local isplaying = currentanimation:WaitForChild("IsPlaying")
	isplaying.Value = playing
end)
