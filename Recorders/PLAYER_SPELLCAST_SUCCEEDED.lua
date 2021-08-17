TheEye.Recorder.Recorders.PLAYER_SPELLCAST_SUCCEEDED = {}
local this = TheEye.Recorder.Recorders.PLAYER_SPELLCAST_SUCCEEDED

local DataRecord = TheEye.Recorder.Managers.Recorders.DataRecord
local EventsRegister = TheEye.Core.Managers.Events.Register
local lastRecordTimestamp
local lastSpellID


function this.Initialize()
    this.gameEvents = { "UNIT_SPELLCAST_SUCCEEDED" }
    EventsRegister(this)
end

function this:OnEvent(event, ...)
    local unit, _, spellID = ...

    if unit == "player" and (lastSpellID ~= spellID or lastRecordTimestamp ~= GetTime()) then
        DataRecord(this, spellID)
        lastRecordTimestamp = GetTime()
        lastSpellID = spellID
    end
end