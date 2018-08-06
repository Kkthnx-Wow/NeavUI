local _, nCore = ...

function nCore:AltBuy()
    if not nCoreDB.AltBuy then return end

    local L = nCore.L
    local select = select

    local NEW_ITEM_VENDOR_STACK_BUY = ITEM_VENDOR_STACK_BUY
    ITEM_VENDOR_STACK_BUY = "|cffa9ff00"..NEW_ITEM_VENDOR_STACK_BUY.."|r"

        -- Alt-click to buy a stack.

    local origMerchantItemButton_OnModifiedClick = _G.MerchantItemButton_OnModifiedClick
    local function MerchantItemButton_OnModifiedClickHook(self, ...)
        origMerchantItemButton_OnModifiedClick(self, ...)

        if IsAltKeyDown() then
            local maxStack = select(8, GetItemInfo(GetMerchantItemLink(self:GetID())))

            local numAvailable = select(5, GetMerchantItemInfo(self:GetID()))

            -- -1 means an item has unlimited supply.
            if numAvailable ~= -1 then
                BuyMerchantItem(self:GetID(), numAvailable)
            else
                BuyMerchantItem(self:GetID(), GetMerchantItemMaxStack(self:GetID()))
            end
        end
    end
    MerchantItemButton_OnModifiedClick = MerchantItemButton_OnModifiedClickHook

        -- Add a hint to the tooltip.

    local function IsMerchantButtonOver()
        return GetMouseFocus():GetName() and GetMouseFocus():GetName():find("MerchantItem%d")
    end

    GameTooltip:HookScript("OnTooltipSetItem", function(self)
        if MerchantFrame:IsShown() and IsMerchantButtonOver() then
            for i = 2, GameTooltip:NumLines() do
                if _G["GameTooltipTextLeft"..i]:GetText():find("<[sS]hift") then
                    GameTooltip:AddLine("|cff00ffcc"..L.AltBuyVendorToolip.."|r")
                end
            end
        end
    end)
end
