-- Name: FreeSlots
-- Author: Specko
-- Description: Displays free inventory slots without opening the bag screen.

local wm = GetWindowManager()
local em = GetEventManager()
local print = d

FreeSlots = {}
FreeSlots.name = "FreeSlots"
FreeSlots.version	= "2.1.8"
FreeSlots.settingsVersion = 1

local settingsDefaults = {
	wm = {
		x = 30,
		y = 1035,
		width = 180,
		height = 100
	}
}

local function initialize(eventCode, addOnName)
	if (addOnName ~= FreeSlots.name) then
		return
	end
	EVENT_MANAGER:UnregisterForEvent("FreeSlots")

	FreeSlots.settings = ZO_SavedVars:New("FreeSlotsSettings" , FreeSlots.settingsVersion, nil, settingsDefaults, nil)

	FreeSlotsUI:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, FreeSlots.settings.wm.x, FreeSlots.settings.wm.y)
	FreeSlotsUI:SetWidth(FreeSlots.settings.wm.width)
	FreeSlotsUI:SetHeight(FreeSlots.settings.wm.height)

	local fragment = ZO_SimpleSceneFragment:New(FreeSlotsUI)
	local sceneHud = SCENE_MANAGER:GetScene("hud")
	local sceneHudUI = SCENE_MANAGER:GetScene("hudui")
	sceneHud:AddFragment(fragment)
	sceneHudUI:AddFragment(fragment)
end

EVENT_MANAGER:RegisterForEvent("FreeSlots" , EVENT_ADD_ON_LOADED , initialize)

local function getAlliancePointsToDisplay()

    ap = 0

    ap = GetAlliancePoints()

    FreeSlotsUIAlliancePointsDisplay:SetText(tostring(ap))

    return ap
end

local function getGoldToDisplay()

    gold = 0

    gold = GetCurrentMoney()

    FreeSlotsUICurrentGoldDisplay:SetText(tostring(gold))

    return gold
end

local function getBankSpaceToDisplay()

    bankSpace = 0

    bankSpace = GetNumBagFreeSlots(BAG_BANK) + GetNumBagFreeSlots(BAG_SUBSCRIBER_BANK)
    totBankSpace = GetBagSize(BAG_BANK) + GetBagSize(BAG_SUBSCRIBER_BANK)

    FreeSlotsUIBankSlotsDisplay:SetText(string.format("%d/%d", bankSpace, totBankSpace))

    return bankSpace
end


local function ShowFreeSlots()

    red = 0
    green = 0
    blue = 0
    alpha = 255
    defaultColor = FreeSlotsUIStatus:GetColor()

    --red
    NoSpace = {}
for i=-1, 5 do
  NoSpace[#NoSpace+1] = i + 1
end

    for k = 1, #NoSpace do
	    if CheckInventorySpaceSilently(NoSpace[k]) == true then
		    red = 255
		    green = 0
		    blue = 0
		    alpha = 255
	    end
    end

    --orange
    SomeSpace = {}
for i=6, 10 do
  SomeSpace[#SomeSpace+1] = i + 1
end

    for k = 1, #SomeSpace do
	    if CheckInventorySpaceSilently(SomeSpace[k]) == true then
		    red = 128
		    green = 0
		    blue = 0
		    alpha = 255
	    end
    end

    --yellow
    DecentSpace = {}
for i=11, 20 do
  DecentSpace[#DecentSpace+1] = i + 1
end

    for k = 1, #DecentSpace do
	    if CheckInventorySpaceSilently(DecentSpace[k]) == true then
		    red = 255
		    green = 255
		    blue = 0
		    alpha = 255
	    end
    end

    --blue
    MediumSpace = {}
for i=21, 30 do
  MediumSpace[#MediumSpace+1] = i + 1
end

    for k = 1, #MediumSpace do
	    if CheckInventorySpaceSilently(MediumSpace[k]) == true then
		    red = 0
		    green = 255
		    blue = 255
		    alpha = 255
	    end
    end

    --green
    PlentyOfSpace = {}
for i=31, 1000 do
  PlentyOfSpace[#PlentyOfSpace+1] = i + 1
end

    for k = 1, #PlentyOfSpace do
	    if CheckInventorySpaceSilently(PlentyOfSpace[k]) == true then
		    red = 0
		    green = 255
		    blue = 0
		    alpha = 255
	    end
    end

    --getBagSpace
    slots = {}
for i=0, 1000 do
  slots[i] = i + 1
end

    for j = 0, #slots do
	    if CheckInventorySpaceSilently(j) == true then
		    bagSpace = j
	    end
    end

    totalSlots = GetBagSize(BAG_BACKPACK)

    FreeSlotsUIStatus:SetColor(red, green, blue, alpha)


    FreeSlotsUIStatus:SetText(string.format("%d/%d", bagSpace, totalSlots))

    getBankSpaceToDisplay()

    getAlliancePointsToDisplay()

    getGoldToDisplay()


    return bagSpace,bagSpaceColor
end

function FreeSlots.OnMoveStop(self)
    FreeSlots.settings.wm.x = self:GetLeft()
    FreeSlots.settings.wm.y = self:GetTop()
    FreeSlots.settings.wm.width = self:GetWidth()
    FreeSlots.settings.wm.height = self:GetHeight()
end

local BufferTable = {}

local function BufferReached(key, buffer)
    if key == nil then return end
    if BufferTable[key] == nil then BufferTable[key] = {} end
    BufferTable[key].buffer = buffer or 3
    BufferTable[key].now = GetFrameTimeSeconds()
    if BufferTable[key].last == nil then BufferTable[key].last = BufferTable[key].now end
    BufferTable[key].diff = BufferTable[key].now - BufferTable[key].last
    BufferTable[key].eval = BufferTable[key].diff >= BufferTable[key].buffer
    if BufferTable[key].eval then BufferTable[key].last = BufferTable[key].now end
    return BufferTable[key].eval
end

function FreeSlots.OnUpdateHandler()
    if not BufferReached("myaddonupdatebuffer", 1) then
	return
    end
    ShowFreeSlots()
end
