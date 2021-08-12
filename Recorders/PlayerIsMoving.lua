TheEye.Recorder.Recorders.PlayerIsMoving = {}
local this = TheEye.Recorder.Recorders.PlayerIsMoving

local DataRecord = TheEye.Recorder.Managers.Recorders.DataRecord
local NotifyBasedFunctionCallerSetup = TheEye.Core.UI.Elements.ListenerGroups.NotifyBasedFunctionCaller.Setup


function this.Initialize()
    this.ListenerGroup =
    {
        Listeners =
        {
            {
                eventEvaluatorKey = "UNIT_IS_MOVING_CHANGED",
                inputValues = { --[[unit]] "player" },
            },
        },
    }
    NotifyBasedFunctionCallerSetup(
        this.ListenerGroup,
        this,
        "Notify"
    )
    this.ListenerGroup:Activate()
end

function this:Notify(event, ...)
    local isMoving = select(1, ...)
    
    local data =
    {
        isMoving = isMoving,
    }
    DataRecord("PlayerIsMoving", data)
end