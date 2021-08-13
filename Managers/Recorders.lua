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
    if _G["TheEyeRecordedData"] == nil then
        _G["TheEyeRecordedData"] = {}
    end
    recordedData = _G["TheEyeRecordedData"]

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

    table.insert(recordedData[recorder.key], { timestamp = GetTime(), data = data})
end