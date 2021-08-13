TheEye.Recorder.Recorders.UNIT_AURA_ACTIVE = {}
local this = TheEye.Recorder.Recorders.UNIT_AURA_ACTIVE

local DataRecord = TheEye.Recorder.Managers.Recorders.DataRecord
local NotifyBasedFunctionCallerSetup = TheEye.Core.UI.Elements.ListenerGroups.NotifyBasedFunctionCaller.Setup
local previousAuras =
{
    player = {},
    target = {},
}
local UnitAuraSpellIDsGet = TheEye.Core.Helpers.Auras.UnitAuraSpellIDsGet


local function DataRecordIfNecessary(unit)
    local currentAuras = UnitAuraSpellIDsGet(unit, nil)
    table.sort(currentAuras)

    if table.areidentical(currentAuras, previousAuras[unit]) == false then
        local data =
        {
            unit = unit,
            spellIDs = currentAuras,
        }
        DataRecord(this, data)
        previousAuras[unit] = currentAuras
    end
end

function this.Initialize()
    this.ListenerGroup =
    {
        Listeners =
        {
            {
                evaluatorKey = "COMBAT_LOG",
                inputValues = { --[[eventName]] "SPELL_AURA_APPLIED", --[[sourceUnit]] "player", --[[destUnit]] "_" },
            },
            {
                evaluatorKey = "COMBAT_LOG",
                inputValues = { --[[eventName]] "SPELL_AURA_BROKEN", --[[sourceUnit]] "player", --[[destUnit]] "_" },
            },
            {
                evaluatorKey = "COMBAT_LOG",
                inputValues = { --[[eventName]] "SPELL_AURA_BROKEN_SPELL", --[[sourceUnit]] "player", --[[destUnit]] "_" },
            },
            {
                evaluatorKey = "COMBAT_LOG",
                inputValues = { --[[eventName]] "SPELL_AURA_REMOVED", --[[sourceUnit]] "player", --[[destUnit]] "_" },
            },
            {
                evaluatorKey = "COMBAT_LOG",
                inputValues = { --[[eventName]] "SPELL_AURA_APPLIED", --[[sourceUnit]] "_", --[[destUnit]] "target" },
            },
            {
                evaluatorKey = "COMBAT_LOG",
                inputValues = { --[[eventName]] "SPELL_AURA_BROKEN", --[[sourceUnit]] "_", --[[destUnit]] "target" },
            },
            {
                evaluatorKey = "COMBAT_LOG",
                inputValues = { --[[eventName]] "SPELL_AURA_BROKEN_SPELL", --[[sourceUnit]] "_", --[[destUnit]] "target" },
            },
            {
                evaluatorKey = "COMBAT_LOG",
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

    DataRecordIfNecessary("player")
    DataRecordIfNecessary("target")
end

function this:Notify(event, inputGroup)
    local sourceUnit = inputGroup.inputValues[2]
    local destUnit = inputGroup.inputValues[3]

    if sourceUnit == "_" then
        DataRecordIfNecessary(destUnit)
    else
        DataRecordIfNecessary(sourceUnit)
    end
end