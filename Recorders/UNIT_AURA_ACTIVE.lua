TheEye.Recorder.Recorders.UNIT_AURA_ACTIVE = {}
local this = TheEye.Recorder.Recorders.UNIT_AURA_ACTIVE

local DataRecord = TheEye.Recorder.Managers.Recorders.DataRecord
local EventsRegister = TheEye.Core.Managers.Events.Register
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

    this.gameEvents = 
    {
        "PLAYER_TARGET_CHANGED",
    }
    EventsRegister(this)

    DataRecordIfNecessary("player")
    DataRecordIfNecessary("target")
end

function this:OnEvent(event) -- PLAYER_TARGET_CHANGED
    DataRecordIfNecessary("target")
end

function this:Notify(event, _, inputGroup)
    local sourceUnit = inputGroup.inputValues[2]
    local destUnit = inputGroup.inputValues[3]

    if sourceUnit == "_" then
        DataRecordIfNecessary(destUnit)
    else
        DataRecordIfNecessary(sourceUnit)
    end
end