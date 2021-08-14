TheEye.Recorder.Recorders.PLAYER_IS_TANKING = {}
local this = TheEye.Recorder.Recorders.PLAYER_IS_TANKING

local DataRecord = TheEye.Recorder.Managers.Recorders.DataRecord
local NotifyBasedFunctionCallerSetup = TheEye.Core.UI.Elements.ListenerGroups.NotifyBasedFunctionCaller.Setup


function this.Initialize()
    this.ListenerGroup =
    {
        Listeners =
        {
            {
                eventEvaluatorKey = "UNIT_THREAT_SITUATION_CHANGED",
                inputValues = { --[[unit]] "player", --[[otherUnit]] "_" },
            },
        },
    }
    NotifyBasedFunctionCallerSetup(
        this.ListenerGroup,
        this,
        "Notify"
    )
    this.ListenerGroup:Activate()

    DataRecord(this, false)
end

function this:Notify(event, ...)
    local threatSituation = select(1, ...)
    local isTanking = threatSituation >= 2

    DataRecord(this, isTanking)
end