BW.upgrade = {};
local MODULE = BW.upgrade;


function MODULE:DamageReducer(dmgtype, reduction)
    
    return function(obj, args) 
        
        local dmginfo = args.dmginfo;
        
        if (dmginfo:IsDamageType( dmgtype )) then 
            dmginfo:SetDamage(dmginfo:GetDamage() * reduction);
    		return args;
    	end
    end

end

function MODULE:HealthIncreaser(increase)

   return function(obj) obj:SetMaxHealth(obj:GetMaxHealth() + increase); obj:SetHealth(obj:GetMaxHealth()); end
end

