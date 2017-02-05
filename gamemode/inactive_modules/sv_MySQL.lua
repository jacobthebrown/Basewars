local MODULE = {}

SQL = {}

// Naming the Module.
MODULE.Name = "MySql"

// Declaring the nessicity for the mysqloo module.
require( "mysqloo" )

// Database information.
local db = mysqloo.connect( "localhost", "root", "FuckMyAss", "players", 3306 )

// Loads module and connects to Database.
function MODULE:Load()

	MsgC( Color( 252, 175, 62 ), "Serverside Module Loaded: MySql \n" )
	db:connect()
	
end

function MODULE:GetTitle()

end

// If the connection to the MySQL Server succeeds then run query test.
function db:onConnected()

    local testQuery = self:query( "SELECT 5+5;" )
		
    function testQuery:onSuccess( data )

    print( "<--------------------Database has connected----------------------->" )

    end

    function testQuery:onError( err, sql )

        print( "Query errored!" )
        print( "Query:", sql )
        print( "Error:", err )

    end

    testQuery:start()

end
// If the connection to the MySQL Server fails then print error.
function db:onConnectionFailed( err )

	print( "<-----------------Connection to database failed!------------------>")
    print( "Error:", err )
	
end

db:connect()

// Verifies if the player's SteamID is valid or null.
local function verifyPlayer(query)
	
	// Declares query data (table) as playerInfo.
    local playerInfo = query:getData()
	
	// if the first entry in the playerInfo table is not null than return true. Else return false.
    if playerInfo[1] ~= nil then
	
		return true
		
    else
	
		return false
		
    end
	
end

//Inserts the player into the Mysql Database.
function SQL:CreatePlayer(data)
	// Created a query to insert player's steamID.
	local insertQuery = db:query("INSERT INTO Players(SteamID) VALUES ('" .. data .. "')")
	
	// Starts query.
	insertQuery:start()	
	
	// Prints on success.
	insertQuery.onSuccess = function(q) 
		print("Player created")
		
		SQL:modifyPlayerData("Wealth",0,data)
		SQL:modifyPlayerData("Name",getNameBySteamID(data),data)
		SQL:modifyPlayerData("Inventory","",data)
		SQL:modifyPlayerData("Weight",0,data)
		
	end
	
	//Prints error on faiure.
	insertQuery.onError = function(q,e) 
		print(e) 
	end
end

//Allows for the modification of player data in the MySQL server.
function SQL:modifyPlayerData(col, data, ID)
		
	//Creating update query to update player data at speficied steamID
	local updateQuery = db:query("UPDATE Players SET ".. col .. "='" .. data .. "' WHERE SteamID='"..ID.."'")
	
	//On success print update.
	updateQuery.onSuccess = function(q) 
		print("Player "..col.." updated to "..data)
	end
	
	//On failure print error.
	updateQuery.onError = function(q,e) 
		print(e) 
	end
	
	//Start query.
	updateQuery:start()

end

//Deletes player data in the Mysql server.
function SQL:deletePlayer(tab, col, data)
		
		//Performing a search query to make sure player exists.
		local searchQuery = db:query("SELECT * FROM "..tab.." WHERE "..col.." = '" .. data .. "'")
		
		//On success delete from query.
		searchQuery.onSuccess = function(q)
		
			//Verifying to player exists.
			if verifyPlayer(q) then
				
				//Creating delete query to delete player.
				local deleteQuery = db:query("DELETE FROM " .. tab .. " WHERE ".. col .." = '" .. data .. "' ")
				
				deleteQuery.onSuccess = function(q) end
				deleteQuery.onError = function(q,e) 
					print(e) 
				end
				
				deleteQuery:start()	
				
				print("Player deleted")
				
			else
				print("Does not exist!")
			end
			
		end
		
		// On failure print.
		searchQuery.onError = function(q,e) 
			print(e) 
		end
		
		//Start search query.
		searchQuery:start()

end

function SQL:fetchPlayerData(ply,field, callback)
		local fetchQuery = db:query("SELECT * FROM Players WHERE SteamID= '" .. ply:SteamID64() .. "'")


		function fetchQuery:onSuccess(q)
	
			if not verifyPlayer(fetchQuery) then
				print("Does Not Exist")
			else
				callback(q[1][field])
			end

		end
		
		function fetchQuery:onError (q,e)
			print(e) 
			return nil
		end
		
		function fetchQuery:OnData(q,data)
			PrintTable(q,data)
		end
		
		fetchQuery:start()

end

concommand.Add( "ShowPlayer", function( ply, cmd, args )

		local verQuery = db:query("SELECT * FROM Players WHERE SteamID= '" .. ply:SteamID64() .. "'")

		verQuery:start()
		
		
		function verQuery:onSuccess (q)
		
		if not verifyPlayer(verQuery) then
			print("Does Not Exist")
		else
			PrintTable(q)
		end

		end
		
		function verQuery:onError (q,e)
			print(e) 
		end


end)

mod.Register(MODULE)