TheEye.Recorder.Recorders.PLAYER_EQUIPMENT = {}
local this = TheEye.Recorder.Recorders.PLAYER_EQUIPMENT

local DataRecord = TheEye.Recorder.Managers.Recorders.DataRecord
local EventsRegister = TheEye.Core.Managers.Events.Register
local GetInventoryItemID = GetInventoryItemID
local previousArmor = {}
local table = table


local function DataRecordIfNecessary()
    local currentArmor = {}
    
    for i = 1, 19 do
        local itemID = GetInventoryItemID("player", i)

        if itemID ~= nil then
            table.insert(currentArmor, itemID)
        end
    end

    if table.areidentical(currentArmor, previousArmor) == false then
        DataRecord(this, currentArmor)
        previousArmor = currentArmor
    end
end

function this.Initialize()
    this.gameEvents = 
    {
        "UNIT_INVENTORY_CHANGED",
    }
    EventsRegister(this)

    DataRecordIfNecessary()
end

function this:OnEvent(event, ...)
    DataRecordIfNecessary()
end