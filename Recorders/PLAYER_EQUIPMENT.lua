TheEye.Recorder.Recorders.PLAYER_EQUIPMENT = {}
local this = TheEye.Recorder.Recorders.PLAYER_EQUIPMENT

local DataRecord = TheEye.Recorder.Managers.Recorders.DataRecord
local EventsRegister = TheEye.Core.Managers.Events.Register
local GetInventoryItemID = GetInventoryItemID
local previousArmor = {}
local table = table
local tostring = tostring


local function DataRecordIfNecessary()
    local currentArmor = {}
    
    for i = 1, 19 do
        local itemID = GetInventoryItemID("player", i)
        local previousItemID = previousArmor[i]

        if itemID ~= previousItemID then
            if previousItemID ~= nil then
                DataRecord(this, previousItemID .. "_" .. tostring(false))
            end

            if itemID ~= nil then
                DataRecord(this, itemID .. "_" .. tostring(true))
            end

            previousArmor[i] = itemID
        end
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