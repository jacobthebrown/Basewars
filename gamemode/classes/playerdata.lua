local PlayerDataClass = {};

PlayerDataClass.money = 0;
PlayerDataClass.nickname = "";
PlayerDataClass.player = nil;

function PlayerData( ply )

	local newPlayer = table.Copy( PlayerDataClass );
	
	newPlayer.money = ply;
	newPlayer.nickname = ply:Nick();
	
	return newPlayer;

end

function PlayerDataClass:MakeSpeak()
    
    if (PlayerDataClass.player != nil) then
        PlayerDataClass.player:Say("Hey!");
    end
    
end

    