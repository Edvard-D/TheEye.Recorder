TheEye.Recorder.Recorders.UNIT_AURA_DURATION = {}
local this = TheEye.Recorder.Recorders.UNIT_AURA_DURATION

local DataRecord = TheEye.Recorder.Managers.Recorders.DataRecord
local DurationCalculateForDataKey = TheEye.Recorder.Managers.Recorders.DurationCalculateForDataKey
local EventsRegister = TheEye.Core.Managers.Events.Register
local GetTime = GetTime
local IsAuraValidForRecord = TheEye.Recorder.Helpers.Auras.IsAuraValidForRecord
local lastUpdateTimestamp = 0
local math = math
local NotifyBasedFunctionCallerSetup = TheEye.Core.UI.Elements.ListenerGroups.NotifyBasedFunctionCaller.Setup
local previousAuras =
{
    player = {},
    target = {},
}
local recordUnits = { 1, 5, 30, 60, 300 } -- seconds
local thresholds = { 10, 30, 120, 300 } -- seconds
local UnitAurasGet = TheEye.Core.Helpers.Auras.UnitAurasGet
local UnitCategoryGet = TheEye.Core.Helpers.Unit.UnitCategoryGet
local updateRate = 1 -- second


local function DataRecordFormatAsString(unit, spellID, remainingDuration, sourceUnitCategory)
    return unit .. "_" .. spellID .. "_" .. remainingDuration .. "_" .. sourceUnitCategory
end

local function DataRecordIfNecessary(destUnit)
    local auras = UnitAurasGet(destUnit, nil)
    local currentAuras = {}
    
    for i = 1, #auras do
        local aura = auras[i]
        local expirationTime = aura[6]
        local sourceUnit = aura[7]
        local sourceUnitCategory = UnitCategoryGet(sourceUnit)

        if expirationTime > 0 and IsAuraValidForRecord(sourceUnit, destUnit, sourceUnitCategory) == true then
            local spellID = aura[10]
            local remainingDuration = DurationCalculateForDataKey(expirationTime - GetTime(), thresholds, recordUnits)
            local unitPreviousAuras = previousAuras[destUnit]
            local dataString = DataRecordFormatAsString(destUnit, spellID, remainingDuration, sourceUnitCategory)

            if unitPreviousAuras[spellID] == nil or unitPreviousAuras[spellID].dataString ~= dataString then
                DataRecord(this, dataString)
                unitPreviousAuras[spellID] =
                {
                    dataString = dataString,
                    sourceUnitCategory = sourceUnitCategory
                }
            end
        end
    end
end

function this.Initialize()
    this.ListenerGroup =
    {
        Listeners =
        {
            {
                eventEvaluatorKey = "COMBAT_LOG",
                inputValues = { --[[eventName]] "SPELL_AURA_APPLIED", --[[sourceUnit]] "player", --[[destUnit]] "_" },
            },
            {
                eventEvaluatorKey = "COMBAT_LOG",
                inputValues = { --[[eventName]] "SPELL_AURA_BROKEN", --[[sourceUnit]] "player", --[[destUnit]] "_" },
            },
            {
                eventEvaluatorKey = "COMBAT_LOG",
                inputValues = { --[[eventName]] "SPELL_AURA_BROKEN_SPELL", --[[sourceUnit]] "player", --[[destUnit]] "_" },
            },
            {
                eventEvaluatorKey = "COMBAT_LOG",
                inputValues = { --[[eventName]] "SPELL_AURA_REMOVED", --[[sourceUnit]] "player", --[[destUnit]] "_" },
            },
            {
                eventEvaluatorKey = "COMBAT_LOG",
                inputValues = { --[[eventName]] "SPELL_AURA_APPLIED", --[[sourceUnit]] "_", --[[destUnit]] "target" },
            },
            {
                eventEvaluatorKey = "COMBAT_LOG",
                inputValues = { --[[eventName]] "SPELL_AURA_BROKEN", --[[sourceUnit]] "_", --[[destUnit]] "target" },
            },
            {
                eventEvaluatorKey = "COMBAT_LOG",
                inputValues = { --[[eventName]] "SPELL_AURA_BROKEN_SPELL", --[[sourceUnit]] "_", --[[destUnit]] "target" },
            },
            {
                eventEvaluatorKey = "COMBAT_LOG",
                inputValues = { --[[eventName]] "SPELL_AURA_REMOVED", --[[sourceUnit]] "_", --[[destUnit]] "target" },
            },
        },
    }
    NotifyBasedFunctionCallerSetup(
        this.ListenerGroup,
        this,
        "Notify"
    )
    this.ListenerGroup:Activate()

    this.customEvents = { "UPDATE" }
    this.gameEvents = { "PLAYER_TARGET_CHANGED" }
    EventsRegister(this)

    DataRecordIfNecessary("player")
    DataRecordIfNecessary("target")
end

function this:OnEvent(event)
    if event == "UPDATE" then
        local currentTime = GetTime()
        
        if currentTime - lastUpdateTimestamp > updateRate then
            lastUpdateTimestamp =  currentTime
            DataRecordIfNecessary("player")
            DataRecordIfNecessary("target")
        end
    else -- PLAYER_TARGET_CHANGED
        DataRecordIfNecessary("target")
    end
end

function this:Notify(event, _, inputGroup)
    local eventData = inputGroup.eventData
    local destUnit = eventData.destUnit

    if destUnit ~= "player" and destUnit ~= "target" then
        return
    end

    if event == "SPELL_AURA_APPLIED" then
        DataRecordIfNecessary(destUnit)
    else -- SPELL_AURA_BROKEN, SPELL_AURA_BROKEN_SPELL, SPELL_AURA_REMOVED
        local unitPreviousAuras = previousAuras[destUnit]
        local spellID = eventData.spellID

        if unitPreviousAuras[spellID] ~= nil then
            local dataString = DataRecordFormatAsString(destUnit, spellID, 0, unitPreviousAuras[spellID].sourceUnitCategory)

            DataRecord(this, dataString)
            unitPreviousAuras[spellID].dataString = dataString
        end
    end
end