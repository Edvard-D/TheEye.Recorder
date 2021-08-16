TheEye.Recorder.Recorders.PLAYER_SPELL_COOLDOWN = {}
local this = TheEye.Recorder.Recorders.PLAYER_SPELL_COOLDOWN

local cooldownGreaterThanZeroFlags = {}
local DataRecord = TheEye.Recorder.Managers.Recorders.DataRecord
local DurationCalculateForDataKey = TheEye.Recorder.Managers.Recorders.DurationCalculateForDataKey
local EventsRegister = TheEye.Core.Managers.Events.Register
local lastEventTimestamp
local listenerGroups = {}
local math = math
local NotifyBasedFunctionCallerSetup = TheEye.Core.UI.Elements.ListenerGroups.NotifyBasedFunctionCaller.Setup
local previousCooldowns = {}
local recordUnits = { 0.5, 5, 30, 60 } -- seconds
local thresholds = { 5, 30, 120 } -- seconds
local trackedSpellIDs = {}


function this.Initialize()
    this.gameEvents = { "UNIT_SPELLCAST_SUCCEEDED" }
    EventsRegister(this)
end

local function ListenerGroupSetup(spellID) 
    local listenerGroup =
    {
        Listeners =
        {
            {
                eventEvaluatorKey = "PLAYER_SPELL_COOLDOWN_DURATION_CHANGED",
                inputValues = { --[[spellID]] spellID },
            },
        },
    }
    NotifyBasedFunctionCallerSetup(
        listenerGroup,
        this,
        "Notify"
    )
    listenerGroups[spellID] = listenerGroup
    listenerGroup:Activate()
end

function this:OnEvent(event, unit, _, spellID)
    if unit == "player" then
        lastEventTimestamp = GetTime()
        ListenerGroupSetup(spellID)
    end
end

function this:Notify(event, cooldown, inputGroup)
    if lastEventTimestamp == GetTime() then
        return
    end

    local spellID = inputGroup.inputValues[1]
    cooldown = DurationCalculateForDataKey(cooldown, thresholds, recordUnits)
    
    if previousCooldowns[spellID] == cooldown then
        return
    end

    if cooldown == 0 and listenerGroups[spellID] ~= nil then
        listenerGroups[spellID]:Deactivate()
        listenerGroups[spellID] = nil

        if cooldownGreaterThanZeroFlags[spellID] ~= nil then
            cooldownGreaterThanZeroFlags[spellID] = nil
            DataRecord(this, spellID .. "_" .. 0)
            previousCooldowns[spellID] = 0
        end
    else
        cooldownGreaterThanZeroFlags[spellID] = true
        DataRecord(this, spellID .. "_" .. cooldown)
        previousCooldowns[spellID] = cooldown
    end
end