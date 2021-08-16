TheEye.Recorder.Recorders.PLAYER_JUMPED = {}
local this = TheEye.Recorder.Recorders.PLAYER_JUMPED

local DataRecord = TheEye.Recorder.Managers.Recorders.DataRecord
local lastDataRecordTimestamp


function this.Initialize()
    hooksecurefunc("JumpOrAscendStart", this.OnPlayerJumped);
end

function this.OnPlayerJumped()
    if GetTime() ~= lastDataRecordTimestamp then
        DataRecord(this, nil)
        lastDataRecordTimestamp = GetTime()
    end
end