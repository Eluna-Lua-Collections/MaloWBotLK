function mb_BossModule_Thaddius_PreOnUpdate()
    if mb_GetDebuffTimeRemaining("player", "Positive Charge") > 0 then
        mb_followMode = "none"
        mb_GoToPosition_SetDestination(0.27263963, 0.13271786, 0.003)
        return mb_GoToPosition_Update()
    elseif mb_GetDebuffTimeRemaining("player", "Negative Charge") > 0 then
        mb_followMode = "none"
        mb_GoToPosition_SetDestination(0.25859490, 0.15420512, 0.003)
        return mb_GoToPosition_Update()
    end
    mb_GoToPosition_Reset()

    local slowFallSpell = nil
    if mb_GetClass("player") == "MAGE" then
        slowFallSpell = "Slow Fall"
    elseif mb_GetClass("player") == "PRIEST" then
        slowFallSpell = "Levitate"
    end
    if slowFallSpell ~= nil then
        if mb_commanderUnit == nil and mb_doAutoRotationAsCommander == false then
            return false
        end
        if mb_commanderUnit == nil and mb_doAutoRotationAsCommander == true then
            local unit = "target"
        else
            local unit = mb_commanderUnit .. "target"
        end
        if not UnitExists(unit) or (UnitName(unit) ~= "Thaddius" and mb_UnitHealthPercentage(unit) < 30) then
            return mb_BossModule_Thaddius_BlanketRaidSlowFall(slowFallSpell)
        end
    end
    return false
end

function mb_BossModule_Thaddius_BlanketRaidSlowFall(spell)
    local members = mb_GetNumPartyOrRaidMembers()
    for i = 1, members do
        local unit = mb_GetUnitFromPartyOrRaidIndex(i)
        if mb_GetBuffTimeRemaining(unit, "Slow Fall") < 3 and mb_GetBuffTimeRemaining(unit, "Levitate") < 3 then
            if mb_IsUnitValidFriendlyTarget(unit, spell) then
                mb_CastSpellOnFriendly(unit, spell)
                return true
            end
        end
    end
    if UnitAffectingCombat("player") then
        mb_SayRaid("Everyone has Slow Fall.")
    end
    return false
end

function mb_BossModule_Thaddius_OnLoad()
    mb_BossModule_PreOnUpdate = mb_BossModule_Thaddius_PreOnUpdate
end

mb_BossModule_RegisterModule("thaddius", mb_BossModule_Thaddius_OnLoad)