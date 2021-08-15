TheEye.Recorder.Recorders.UNIT_AURA_STACK_COUNT = {}
local this = TheEye.Recorder.Recorders.UNIT_AURA_STACK_COUNT

local DataRecord = TheEye.Recorder.Managers.Recorders.DataRecord
local EventsRegister = TheEye.Core.Managers.Events.Register
local NotifyBasedFunctionCallerSetup = TheEye.Core.UI.Elements.ListenerGroups.NotifyBasedFunctionCaller.Setup
local previousAuras =
{
    player = {},
    target = {},
}
local UnitAurasGet = TheEye.Core.Helpers.Auras.UnitAurasGet
local UnitCategoryGet = TheEye.Core.Helpers.Unit.UnitCategoryGet


local function DataRecordIfNecessary(unit)
    local auras = UnitAurasGet(unit, nil)
    local currentAuras = {}

    for i = 1, #auras do
        local aura = auras[i]
        local stackCount = aura[3]
        local sourceUnit = aura[7]
        local spellID = aura[10]

        if stackCount > 0 then
            table.insert(currentAuras, unit .. "_" .. spellID .. "_" .. stackCount .. "_" .. UnitCategoryGet(sourceUnit))
        end
    end

    table.sort(currentAuras)

    if table.areidentical(currentAuras, previousAuras[unit]) == false then
        DataRecord(this, currentAuras)
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
    local sourceUnit = inputGroup.inputValues[2]
    local destUnit = inputGroup.inputValues[3]

    if sourceUnit == "_" then
        DataRecordIfNecessary(destUnit)
    else
        DataRecordIfNecessary(sourceUnit)
    end
end