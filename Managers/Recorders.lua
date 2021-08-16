TheEye.Recorder.Managers.Recorders = {}
local this = TheEye.Recorder.Managers.Recorders

local EventsRegister = TheEye.Core.Managers.Events.Register
local GetTime = GetTime
local recordedData = nil
local table = table


function this.Initialize()
    this.gameEvents = { "PLAYER_ENTERING_WORLD" }
    EventsRegister(this)
end

function this:OnEvent(event, ...)
    -- Previously saved data is intentionally overwritten every time the UI is reloaded
    _G["TheEyeRecordedData"] = {}
    recordedData = _G["TheEyeRecordedData"]
    collectgarbage()

    for key, recorder in pairs(TheEye.Recorder.Recorders) do
        recorder.key = key

        if recorder.Initialize ~= nil then
            recorder.Initialize()
        end
    end
end

-- Expects data to be a numerical, boolean, or string value.
function this.DataRecord(recorder, data)
    if recordedData[recorder.key] == nil then
        recordedData[recorder.key] = {}
    end

    local recorderData = recordedData[recorder.key]

    if data ~= nil then
        data = tostring(data)
        
        if recorderData[data] == nil then
            recorderData[data] = {}
        end

        table.insert(recorderData[data], GetTime())
    else
        table.insert(recorderData, GetTime())
    end
end

local function RecordUnitGet(duration, thresholds, recordUnits)
    for i = 1, #thresholds do
        if duration <= thresholds[i] then
            return recordUnits[i]
        end
    end

    return recordUnits[#recordUnits]
end

-- Used to reduce the number of data keys when a time element is involved, as some durations can have very long.
-- Example use cases include cooldowns, aura durations, time until death, etc. recordUnits should always have one
-- more element than thresholds, as the last recordUnits value is treated as the default.
function this.DurationCalculateForDataKey(duration, thresholds, recordUnits)
    local recordUnit = RecordUnitGet(duration, thresholds, recordUnits)
    return math.ceil(duration / recordUnit) * recordUnit
end