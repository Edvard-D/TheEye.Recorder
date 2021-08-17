TheEye.Recorder.Recorders.PLAYER_SUMMONED_ACTIVE_ELAPSED_TIME = {}
local this = TheEye.Recorder.Recorders.PLAYER_SUMMONED_ACTIVE_ELAPSED_TIME

local DataRecord = TheEye.Recorder.Managers.Recorders.DataRecord
local DurationCalculateForDataKey = TheEye.Recorder.Managers.Recorders.DurationCalculateForDataKey
local EventsRegister = TheEye.Core.Managers.Events.Register
local GetTime = GetTime
local lastDestGUID
local lastSpellID
local lastUpdateTimestamp = 0
local NotifyBasedFunctionCallerSetup = TheEye.Core.UI.Elements.ListenerGroups.NotifyBasedFunctionCaller.Setup
local previousValues = {}
local recordUnits = { 1, 5, 30, 60, "INF" } -- seconds
local spellCastRecordTimestamp
local summonedRecordTimestamp
local thresholds = { 10, 30, 120, 600 } -- seconds
local trackedSpellIDToSummonedTimes = {}
local trackedGUIDToSpellIDs = {}
local updateRate = 1 -- second


local function DataRecordIfNecessary()
    for spellID, summonedTime in pairs(trackedSpellIDToSummonedTimes) do
        local elpasedTime = GetTime() - summonedTime
        elpasedTime = DurationCalculateForDataKey(elpasedTime, thresholds, recordUnits)

        if previousValues[spellID] ~= elpasedTime then
            DataRecord(this, spellID .. "_" .. elpasedTime)
            previousValues[spellID] = elpasedTime
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
                inputValues = { --[[eventName]] "SPELL_SUMMON", --[[sourceUnit]] "player", --[[destUnit]] "_" },
            },
            {
                eventEvaluatorKey = "COMBAT_LOG",
                inputValues = { --[[eventName]] "UNIT_DESTROYED", --[[sourceUnit]] "_", --[[destUnit]] "_" },
            },
            {
                eventEvaluatorKey = "COMBAT_LOG",
                inputValues = { --[[eventName]] "UNIT_DIED", --[[sourceUnit]] "_", --[[destUnit]] "_" },
            },
            {
                eventEvaluatorKey = "COMBAT_LOG",
                inputValues = { --[[eventName]] "UNIT_DISSIPATES", --[[sourceUnit]] "_", --[[destUnit]] "_" },
            },
        },
    }
    NotifyBasedFunctionCallerSetup(
        this.ListenerGroup,
        this,
        "Notify"
    )
    this.ListenerGroup:Activate()

    this.gameEvents = { "UNIT_SPELLCAST_SUCCEEDED" }
    this.customEvents = { "UPDATE" }
    EventsRegister(this)
end

function this:OnEvent(event, ...)
    if event == "UPDATE" then
        if GetTime() - lastUpdateTimestamp >= updateRate then
            DataRecordIfNecessary()
            lastUpdateTimestamp = GetTime()
        end
    else -- UNIT_SPELLCAST_SUCCEEDED
        local unit, _, spellID = ...
        
        if unit == "player" then
            if summonedRecordTimestamp == GetTime() then
                trackedSpellIDToSummonedTimes[spellID] = GetTime()
                trackedGUIDToSpellIDs[lastDestGUID] = spellID
                DataRecordIfNecessary()
            else
                lastSpellID = spellID
                spellCastRecordTimestamp = GetTime()
            end
        end
    end
end

function this:Notify(event, _, inputGroup)
    local eventData = inputGroup.eventData

    if event == "SPELL_SUMMON" then
        if spellCastRecordTimestamp == GetTime() then
            trackedSpellIDToSummonedTimes[lastSpellID] = GetTime()
            trackedGUIDToSpellIDs[eventData.destGUID] = lastSpellID
            DataRecordIfNecessary()
        else
            summonedRecordTimestamp = GetTime()
            lastDestGUID = eventData.destGUID
        end
    else -- UNIT_DESTROYED, UNIT_DIED, UNIT_DISSIPATES
        local spellID = trackedGUIDToSpellIDs[eventData.destGUID]
        
        if spellID ~= nil then
            DataRecordIfNecessary()
            trackedSpellIDToSummonedTimes[spellID] = nil
            trackedGUIDToSpellIDs[eventData.destGUID] = nil
        end
    end
end