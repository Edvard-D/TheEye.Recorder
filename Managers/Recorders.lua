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

    local dataTable = { timestamp = GetTime() }
    if data ~= nil then
        dataTable.data = data
    end

    table.insert(recordedData[recorder.key], dataTable)
end