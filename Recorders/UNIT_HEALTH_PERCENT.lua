TheEye.Recorder.Recorders.UNIT_HEALTH_PERCENT = {}
local this = TheEye.Recorder.Recorders.UNIT_HEALTH_PERCENT

local DataRecord = TheEye.Recorder.Managers.Recorders.DataRecord
local math = math
local NotifyBasedFunctionCallerSetup = TheEye.Core.UI.Elements.ListenerGroups.NotifyBasedFunctionCaller.Setup


function this.Initialize()
    this.ListenerGroup =
    {
        Listeners =
        {
            {
                eventEvaluatorKey = "UNIT_HEALTH_PERCENT_CHANGED",
                inputValues = { --[[unit]] "player" },
            },
            {
                eventEvaluatorKey = "UNIT_HEALTH_PERCENT_CHANGED",
                inputValues = { --[[unit]] "target" },
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

function this:Notify(event, healthPercent, inputGroup)
    local unit = inputGroup.inputValues[1]
    healthPercent = math.floor(healthPercent + 0.5)
    DataRecord(this, unit .. "_" .. healthPercent)
end