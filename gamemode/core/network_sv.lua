function InitializeNetworkStrings()
	util.AddNetworkString( "Entity_SendGameDataSingle" );
	util.AddNetworkString( "Entity_SendGameDataMany" );

end
hook.Add( "Initialize", "Hook_InitializeNetworkStrings", InitializeNetworkStrings )