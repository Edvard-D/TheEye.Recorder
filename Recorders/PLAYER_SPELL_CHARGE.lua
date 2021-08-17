TheEye.Recorder.Recorders.PLAYER_SPELL_CHARGE = {}
local this = TheEye.Recorder.Recorders.PLAYER_SPELL_CHARGE

local CurrentSpellsGet = TheEye.Core.Helpers.Spells.CurrentSpellsGet
local DataRecord = TheEye.Recorder.Managers.Recorders.DataRecord
local EventsRegister = TheEye.Core.Managers.Events.Register
local GetSpellCharges = GetSpellCharges
local previousValues = {}
local select = select


local function DataRecordIfNecessary()
    local currentSpellIDs = CurrentSpellsGet(true)

    for i = 1, #currentSpellIDs do
        local spellID = currentSpellIDs[i]
        local charges = select(1, GetSpellCharges(spellID))

        if charges ~= nil and previousValues[spellID] ~= charges then
            DataRecord(this, spellID .. "_" .. charges)
            previousValues[spellID] = charges
        end
    end
end

function this.Initialize()
    this.gameEvents = { "SPELL_UPDATE_CHARGES" }
    EventsRegister(this)
    
    DataRecordIfNecessary()
end

function this:OnEvent(event, unit, _, spellID)
    DataRecordIfNecessary()
end