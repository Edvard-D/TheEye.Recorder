TheEye.Recorder.Recorders.PLAYER_SPELL_IS_KNOWN = {}
local this = TheEye.Recorder.Recorders.PLAYER_SPELL_IS_KNOWN

local CurrentSpellsGet = TheEye.Core.Helpers.Spells.CurrentSpellsGet
local DataRecord = TheEye.Recorder.Managers.Recorders.DataRecord
local EventsRegister = TheEye.Core.Managers.Events.Register
local previousSpellIDs = {}
local table = table
local tostring = tostring


local function DataRecordIfNecessary()
    local currentSpellIDs = CurrentSpellsGet(true)

    for i = 1, #currentSpellIDs do
        local spellID = currentSpellIDs[i]

        if table.hasvalue(previousSpellIDs, spellID) == false then
            DataRecord(this, spellID .. "_" .. tostring(true))
        end
    end

    for i = 1, #previousSpellIDs do
        local spellID = previousSpellIDs[i]

        if table.hasvalue(currentSpellIDs, spellID) == false then
            DataRecord(this, spellID .. "_" .. tostring(false))
        end
    end

    previousSpellIDs = currentSpellIDs
end

function this.Initialize()
    this.gameEvents = { "SPELLS_CHANGED" }
    EventsRegister(this)
    
    DataRecordIfNecessary()
end

function this:OnEvent(event, unit, _, spellID)
    DataRecordIfNecessary()
end