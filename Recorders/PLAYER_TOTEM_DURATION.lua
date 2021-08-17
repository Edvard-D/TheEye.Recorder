TheEye.Recorder.Recorders.PLAYER_TOTEM_DURATION = {}
local this = TheEye.Recorder.Recorders.PLAYER_TOTEM_DURATION

local DataRecord = TheEye.Recorder.Managers.Recorders.DataRecord
local DurationCalculateForDataKey = TheEye.Recorder.Managers.Recorders.DurationCalculateForDataKey
local EventsRegister = TheEye.Core.Managers.Events.Register
local GetTime = GetTime
local GetTotemInfo = GetTotemInfo
local lastUpdateRecordTimestamp = 0
local previousValues = {}
local recordUnits = { 1, 5, 30 } -- seconds
local table = table
local thresholds = { 10, 30 } -- seconds
local tostring = tostring
local trackedTotemSlots = {}
local updateRecordRate = 1 -- second


local function DataRecordIfNecessary()
    for i = 1, #trackedTotemSlots do
        local _, totemName, startTime, duration = GetTotemInfo(trackedTotemSlots[i])
        local remainingDuration = duration - (GetTime() - startTime)

        if remainingDuration < 0 then
            if previousValues[totemName] ~= nil then
                remainingDuration = 0
            else
                return
            end
        elseif previousValues[totemName] ~= nil then
            remainingDuration = DurationCalculateForDataKey(remainingDuration, thresholds, recordUnits)
        else
            remainingDuration = duration
        end

        if previousValues[totemName] ~= remainingDuration
            and (previousValues[totemName] ~= nil or remainingDuration ~= 0)
            then
            DataRecord(this, totemName .. "_" .. remainingDuration)
            previousValues[totemName] = remainingDuration
        end

        if remainingDuration == 0 then
            previousValues[totemName] = nil
        end
    end
end

function this.Initialize()
    this.customEvents = { "UPDATE" }
    this.gameEvents = { "PLAYER_TOTEM_UPDATE" }
    EventsRegister(this)
end

function this:OnEvent(event, ...)
    if event == "UPDATE" then
        if GetTime() - lastUpdateRecordTimestamp >= updateRecordRate then
            DataRecordIfNecessary()
            lastUpdateRecordTimestamp = GetTime()
        end
    else -- PLAYER_TOTEM_UPDATE
        local totemSlot = ...

        if table.hasvalue(trackedTotemSlots, totemSlot) == false then
            table.insert(trackedTotemSlots, totemSlot)
        end
        
        DataRecordIfNecessary()
    end
end