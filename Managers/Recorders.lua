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
    recordedData = _G["TheEyeRecordedData"]

    for k, recorder in pairs(TheEye.Recorder.Recorders) do
        if recorder.Initialize ~= nil then
            recorder.Initialize()
        end
    end
end

function this:DataRecord(dataType, data)
    data.timestamp = GetTime()

    if recordedData[dataType] == nil then
        recordedData[dataType] = {}
    end

    table.insert(recordedData[dataType], data)
end