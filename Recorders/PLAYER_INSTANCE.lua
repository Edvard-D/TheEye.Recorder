TheEye.Recorder.Recorders.PLAYER_INSTANCE = {}
local this = TheEye.Recorder.Recorders.PLAYER_INSTANCE

local DataRecord = TheEye.Recorder.Managers.Recorders.DataRecord
local EventsRegister = TheEye.Core.Managers.Events.Register
local GetInstanceInfo = GetInstanceInfo
local select = select


function this.Initialize()
    this.gameEvents = { "PLAYER_ENTERING_WORLD" }
    EventsRegister(this)

    local instanceID = select(8, GetInstanceInfo)
    DataRecord(this, instanceID)
end

function this:OnEvent(event, ...)
    local instanceID = select(8, GetInstanceInfo)
    DataRecord(this, instanceID)
end