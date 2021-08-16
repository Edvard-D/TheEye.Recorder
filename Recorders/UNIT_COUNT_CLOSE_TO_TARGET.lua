TheEye.Recorder.Recorders.UNIT_COUNT_CLOSE_TO_TARGET = {}
local this = TheEye.Recorder.Recorders.UNIT_COUNT_CLOSE_TO_TARGET

local DataRecord = TheEye.Recorder.Managers.Recorders.DataRecord
local NotifyBasedFunctionCallerSetup = TheEye.Core.UI.Elements.ListenerGroups.NotifyBasedFunctionCaller.Setup
local previousCounts = {}


function this.Initialize()
    this.ListenerGroup =
    {
        Listeners =
        {
            {
                eventEvaluatorKey = "UNIT_COUNT_CLOSE_TO_UNIT_CHANGED",
                inputValues = { --[[unit]] "target", --[[hostilityMask]] COMBATLOG_OBJECT_REACTION_HOSTILE, },
            },
            {
                eventEvaluatorKey = "UNIT_COUNT_CLOSE_TO_UNIT_CHANGED",
                inputValues = { --[[unit]] "target", --[[hostilityMask]] COMBATLOG_OBJECT_REACTION_FRIENDLY, },
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

function this:Notify(event, unitCount, inputGroup)
    local hostilityMask = inputGroup.inputValues[2]
    local hostility

    if hostilityMask == COMBATLOG_OBJECT_REACTION_HOSTILE then
        hostility = "HOSTILE"
    else
        hostility = "FRIENDLY"
    end
    
    if previousCounts[hostility] ~= unitCount then
        DataRecord(this, hostility .. "_" .. unitCount)
        previousCounts[hostility] = unitCount
    end
end