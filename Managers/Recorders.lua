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
        if recorderData[data] == nil then
            recorderData[data] = {}
        end

        table.insert(recorderData[data], GetTime())
    else
        table.insert(recorderData, GetTime())
    end
end