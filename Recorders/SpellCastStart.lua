TheEye.Recorder.Recorders.SpellCastStart = {}
local this = TheEye.Recorder.Recorders.SpellCastStart

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
        local data =
        {
            unitGUID = UnitGUID(unit),
            spellID = spellID,
        }
        DataRecord("SpellCastStart", data)
    end
end