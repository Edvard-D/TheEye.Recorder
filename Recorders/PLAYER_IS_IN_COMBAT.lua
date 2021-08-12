TheEye.Recorder.Recorders.PLAYER_IS_IN_COMBAT = {}
local this = TheEye.Recorder.Recorders.PLAYER_IS_IN_COMBAT

local DataRecord = TheEye.Recorder.Managers.Recorders.DataRecord
local EventsRegister = TheEye.Core.Managers.Events.Register
local UnitAffectingCombat = UnitAffectingCombat


function this.Initialize()
    this.gameEvents =
    {
        "PLAYER_REGEN_DISABLED",
        "PLAYER_REGEN_ENABLED",
    }
    EventsRegister(this)

    local data =
    {
        isInCombat = UnitAffectingCombat("player"),
    }
    DataRecord(this, data)
end

function this:OnEvent(event, ...)
    local data =
    {
        isInCombat = event == "PLAYER_REGEN_DISABLED",
    }
    DataRecord(this, data)
end