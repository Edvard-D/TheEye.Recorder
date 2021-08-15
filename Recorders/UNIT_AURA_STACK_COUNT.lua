TheEye.Recorder.Recorders.UNIT_AURA_STACK_COUNT = {}
local this = TheEye.Recorder.Recorders.UNIT_AURA_STACK_COUNT

local DataRecord = TheEye.Recorder.Managers.Recorders.DataRecord
local EventsRegister = TheEye.Core.Managers.Events.Register
local IsAuraValidForRecord = TheEye.Recorder.Helpers.Auras.IsAuraValidForRecord
local NotifyBasedFunctionCallerSetup = TheEye.Core.UI.Elements.ListenerGroups.NotifyBasedFunctionCaller.Setup
local previousAuras =
{
    player = {},
    target = {},
}
local UnitAurasGet = TheEye.Core.Helpers.Auras.UnitAurasGet
local UnitCategoryGet = TheEye.Core.Helpers.Unit.UnitCategoryGet


local function DataRecordFormatAsString(unit, spellID, stackCount, sourceUnitCategory)
    return unit .. "_" .. spellID .. "_" .. stackCount .. "_" .. sourceUnitCategory
end

local function DataRecordIfNecessary(unit)
    local auras = UnitAurasGet(unit, nil)
    local currentAuras = {}

    for i = 1, #auras do
        local aura = auras[i]
        local stackCount = aura[3]
        local sourceUnit = aura[7]
        local sourceUnitCategory = UnitCategoryGet(sourceUnit)

        if stackCount > 0 and IsAuraValidForRecord(sourceUnit, destUnit, sourceUnitCategory) == true then
            local spellID = aura[10]
            local unitPreviousAuras = previousAuras[destUnit]
            local dataString = DataRecordFormatAsString(destUnit, spellID, stackCount, sourceUnitCategory)

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
                inputValues = { --[[eventName]] "SPELL_AURA_APPLIED_DOSE", --[[sourceUnit]] "player", --[[destUnit]] "_" },
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
                inputValues = { --[[eventName]] "SPELL_AURA_APPLIED_DOSE", --[[sourceUnit]] "_", --[[destUnit]] "target" },
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

    this.gameEvents = { "PLAYER_TARGET_CHANGED" }
    EventsRegister(this)

    DataRecordIfNecessary("player")
    DataRecordIfNecessary("target")
end

function this:OnEvent(event) -- PLAYER_TARGET_CHANGED
    DataRecordIfNecessary("target")
end

function this:Notify(event, _, inputGroup)
    local eventData = inputGroup.eventData
    local destUnit = eventData.destUnit

    if destUnit ~= "player" and destUnit ~= "target" then
        return
    end

    if event == "SPELL_AURA_APPLIED" or event == "SPELL_AURA_APPLIED_DOSE" then
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