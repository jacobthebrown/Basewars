net.Receive( "Entity_MoneyPrinter_GetBalance", function()
	 local money = net.ReadUInt(32);
	 chat.AddText( "Money Printer Balance: " .. tostring(money) );
end )


net.Receive( "Entity_SendGameData", function( msgLength )

	print("Swag")
	
	local targetEntity = net.ReadEntity();
	
        targetEntity.gamedata = net.ReadTable();
        
        PrintTable(targetEntity.gamedata)
        
end )