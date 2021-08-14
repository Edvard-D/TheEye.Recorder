TheEye.Recorder.Recorders.PLAYER_JUMPED = {}
local this = TheEye.Recorder.Recorders.PLAYER_JUMPED

local DataRecord = TheEye.Recorder.Managers.Recorders.DataRecord


function this.Initialize()
    hooksecurefunc("JumpOrAscendStart", this.OnPlayerJumped);
end

function this.OnPlayerJumped()
    DataRecord(this, nil)
end