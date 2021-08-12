TheEye.Recorder.Recorders.PLAYER_TALENT = {}
local this = TheEye.Recorder.Recorders.PLAYER_TALENT

local DataRecord = TheEye.Recorder.Managers.Recorders.DataRecord
local EventsRegister = TheEye.Core.Managers.Events.Register
local GetTalentInfo = GetTalentInfo
local previousTalents = {}
local table = table
local talentColumns = 3
local talentRows = 7


local function DataRecordIfNecessary()
    local currentTalents = {}
    
    for row = 1, TheEye.Analyzer.Data.talentRows do
        for column = 1, TheEye.Analyzer.Data.talentColumns do
            local talentID, _, _, isSelected = GetTalentInfo(row, column, 1)
            
            if isSelected == true then
                table.insert(currentTalents, talentID)
            end
        end
    end

    if table.areidentical(currentTalents, previousTalents) == false then
        local data = { talentIDs = currentTalents }
        DataRecord(this, data)
        previousTalents = currentTalents
    end
end

function this.Initialize()
    this.gameEvents = 
    {
        "PLAYER_TALENT_UPDATE",
        "UNIT_INVENTORY_CHANGED",
    }
    EventsRegister(this)

    DataRecordIfNecessary()
end

function this:OnEvent(event, ...)
    DataRecordIfNecessary()
end