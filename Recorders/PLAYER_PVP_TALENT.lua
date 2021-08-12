TheEye.Recorder.Recorders.PLAYER_PVP_TALENT = {}
local this = TheEye.Recorder.Recorders.PLAYER_PVP_TALENT

local DataRecord = TheEye.Recorder.Managers.Recorders.DataRecord
local EventsRegister = TheEye.Core.Managers.Events.Register
local GetAllSelectedPvpTalentIDs = C_SpecializationInfo.GetAllSelectedPvpTalentIDs
local table = table


local function DataRecordIfNecessary()
    local currentTalents = GetAllSelectedPvpTalentIDs()

    if table.areidentical(currentTalents, previousTalents) == false then
        local data = { talentIDs = currentTalents }
        DataRecord(this, data)
        previousTalents = currentTalents
    end
end

function this.Initialize()
    this.gameEvents = 
    {
        "PLAYER_PVP_TALENT_UPDATE",
        "UNIT_INVENTORY_CHANGED",
    }
    EventsRegister(this)

    DataRecordIfNecessary()
end

function this:OnEvent(event, ...)
    DataRecordIfNecessary()
end