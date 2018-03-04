function InitializeNetworkStrings()
	util.AddNetworkString( "GameObject_SendGameDataSingle" );
	util.AddNetworkString( "GameObject_SendGameDataMany" );

end
hook.Add( "Initialize", "Hook_InitializeNetworkStrings", InitializeNetworkStrings )