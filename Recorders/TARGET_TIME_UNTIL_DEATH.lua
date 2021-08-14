TheEye.Recorder.Recorders.TARGET_TIME_UNTIL_DEATH = {}
local this = TheEye.Recorder.Recorders.TARGET_TIME_UNTIL_DEATH

local DataRecord = TheEye.Recorder.Managers.Recorders.DataRecord
local dataRecordRate = 1 -- second
local EventsRegister = TheEye.Core.Managers.Events.Register
local healthChangePerSecondLookbackDuration = 30 -- seconds
local healthChangeRecordUnit = 10 -- seconds
local lastDataRecordTimestamp = 0
local math = math
local NotifyBasedFunctionCallerSetup = TheEye.Core.UI.Elements.ListenerGroups.NotifyBasedFunctionCaller.Setup
local previousTargetTimeUntilDeath = 0
local targetHealthChangePerSecond = 0
local UnitGUID = UnitGUID
local UnitHealth = UnitHealth


local function DataRecordIfNecessary()
    if targetHealthChangePerSecond >= 0 then
        DataRecord(this, math.huge)
        return
    end

    local targetTimeUntilDeath = UnitHealth("target") / (targetHealthChangePerSecond * -1)
    targetTimeUntilDeath = math.ceil(targetTimeUntilDeath / healthChangeRecordUnit) * healthChangeRecordUnit

    if targetTimeUntilDeath ~= previousTargetTimeUntilDeath
        and GetTime() - lastDataRecordTimestamp >= dataRecordRate
        then
        previousTargetTimeUntilDeath = targetTimeUntilDeath
        lastDataRecordTimestamp = GetTime()
        DataRecord(this, targetTimeUntilDeath)
    end
end

function this.Initialize()
    this.gameEvents =
    {
        "PLAYER_TARGET_CHANGED",
        "UNIT_HEALTH",
    }
    EventsRegister(this)
end

function this:OnEvent(event, ...)
    if event == "PLAYER_TARGET_CHANGED" then
        if this.ListenerGroup ~= nil then
            this.ListenerGroup:Deactivate()
        end

        local unitGUID = UnitGUID("target")
        if unitGUID == nil then
            return
        end
        
        this.ListenerGroup =
        {
            Listeners =
            {
                {
                    eventEvaluatorKey = "UNIT_HEALTH_CHANGE_PER_SECOND_CHANGED",
                    inputValues = { --[[unitGUID]] unitGUID, --[[lookbackDuration]] healthChangePerSecondLookbackDuration },
                },
            },
        }
        NotifyBasedFunctionCallerSetup(
            this.ListenerGroup,
            this,
            "Notify"
        )
        this.ListenerGroup:Activate()
    else -- UNIT_HEALTH
        local unit = ...

        if unit == "target" then
            DataRecordIfNecessary()
        end
    end
end

function this:Notify(event, healthChangePerSecond)
    targetHealthChangePerSecond = healthChangePerSecond
    DataRecordIfNecessary()
end