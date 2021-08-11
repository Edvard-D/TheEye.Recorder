TheEye.Recorder.Managers.Recorders = {}
local this = TheEye.Recorder.Managers.Recorders

local EventsRegister = TheEye.Core.Managers.Events.Register


function this.Initialize()
    this.gameEvents = { "PLAYER_ENTERING_WORLD" }
    EventsRegister(this)
end

function this:OnEvent(event, ...)
    for k, recorder in pairs(TheEye.Recorder.Recorders) do
        if recorder.Initialize ~= nil then
            recorder.Initialize()
        end
    end
end