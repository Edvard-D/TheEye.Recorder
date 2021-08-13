TheEye.Recorder.Recorders.PLAYER_SPELL_CAST_START = {}
local this = TheEye.Recorder.Recorders.PLAYER_SPELL_CAST_START

local DataRecord = TheEye.Recorder.Managers.Recorders.DataRecord
local EventsRegister = TheEye.Core.Managers.Events.Register
local UnitGUID = UnitGUID


function this.Initialize()
    this.gameEvents = { "UNIT_SPELLCAST_START" }
    EventsRegister(this)
end

function this:OnEvent(event, ...)
    unit, _, spellID = ...

    if unit == "player" then
        DataRecord(this, spellID)
    end
end