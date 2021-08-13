TheEye.Recorder.Recorders.TARGET_IS_HOSITLE = {}
local this = TheEye.Recorder.Recorders.TARGET_IS_HOSITLE

local DataRecord = TheEye.Recorder.Managers.Recorders.DataRecord
local NotifyBasedFunctionCallerSetup = TheEye.Core.UI.Elements.ListenerGroups.NotifyBasedFunctionCaller.Setup


function this.Initialize()
    this.ListenerGroup =
    {
        Listeners =
        {
            {
                eventEvaluatorKey = "UNIT_IS_HOSTILE_CHANGED",
                inputValues = { --[[unit2]] "player", --[[unit2]] "target" },
            },
        },
    }
    NotifyBasedFunctionCallerSetup(
        this.ListenerGroup,
        this,
        "Notify"
    )
    this.ListenerGroup:Activate()

    local data =
    {
        isHostile = UnitIsEnemy("player", "target"),
    }
    DataRecord(this, data)
end

function this:Notify(event, isHostile)
    DataRecord(this, isHostile)
end