local var = dofile('/scripts/copilot/var.lua')
local util = dofile('/scripts/copilot/util.lua')
local module = {}

local moduleX = 0
local moduleY = 0
local moduleWidth = 180
local moduleHeight = 50

local rxBatt = 0
local rxBattMin = var.MAX
local rxBattMax = 0

function module.wakeup(widget)
  local source = system.getSource({ name='RxBatt' })
  if source == nil then
    local _rxBatt = 0
    if _rxBatt ~= rxBatt then
      rxBatt = _rxBatt
      lcd.invalidate(moduleX, moduleY, moduleWidth, moduleHeight)
    end
  else
    local _rxBatt = source:value()
    if _rxBatt ~= rxBatt then
      rxBatt = _rxBatt
      if _rxBatt > rxBattMax then rxBattMax = _rxBatt end
      if rxBattMin == 0 then rxBattMin = rxBattMax end
      if _rxBatt < rxBattMin then rxBattMin = _rxBatt end
      lcd.invalidate(moduleX, moduleY, moduleWidth, moduleHeight)
    end
  end
end

function module.paint(widget, x, y)
  local xStart = x + 15
  local yStart = y

  if moduleX ~= xStart then moduleX = xStart end
  if moduleY ~= yStart then moduleY = yStart end

  util.drawChar(widget, xStart, yStart, string.format('%04.2f%s', rxBatt, 'V'))

  lcd.color(textColor)
  lcd.font(FONT_L_BOLD)
  lcd.drawText(xStart + 40, yStart + 66, string.format('%04.2f%s%04.2f%s', rxBattMin == var.MAX and 0 or rxBattMin, ' .. ' , rxBattMax, ' v'))
end

return module