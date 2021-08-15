TheEye.Recorder.Recorders.PLAYER_PVP_TALENT = {}
local this = TheEye.Recorder.Recorders.PLAYER_PVP_TALENT

local DataRecord = TheEye.Recorder.Managers.Recorders.DataRecord
local EventsRegister = TheEye.Core.Managers.Events.Register
local GetAllSelectedPvpTalentIDs = C_SpecializationInfo.GetAllSelectedPvpTalentIDs
local previousTalents = {}
local table = table


local function DataRecordIfNecessary()
    local currentTalents = GetAllSelectedPvpTalentIDs()

    for i = 1, #currentTalents do
        local talentID = currentTalents[i]

        if table.hasvalue(previousTalents, talentID) == false then
            DataRecord(this, talentID .. "_" .. tostring(true))
        end
    end

    for i = 1, #previousTalents do
        local talentID = previousTalents[i]

        if table.hasvalue(currentTalents, talentID) == false then
            DataRecord(this, talentID .. "_" .. tostring(false))
        end
    end

    previousTalents = currentTalents
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