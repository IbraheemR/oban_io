require "/scripts/dpxObject.lua"

function init()
  object.setInteractive(true)
  dpx.init()

  storage.pixels = storage.pixels or 0
end

function update(dt)
  -- Request power
  if storage.dpx < dpx.maxStore then -- ensure we dont just eat power
    for id, node in pairs(self.dpxInputConnections) do
      dpx.sendRequest(id, node, dpx.ALL) -- draw 5 dPx
    end
  end

  -- Attempt to generate pixels & update animation state
  if storage.dpx >= config.getParameter("dpxPixelRatio") then
    storage.dpx = storage.dpx - config.getParameter("dpxPixelRatio")
    storage.pixels = storage.pixels + 1

    animator.setAnimationState("crankState", "active")
  else
    animator.setAnimationState("crankState", "idle")
  end

end

function onInteraction(args)
  if storage.pixels > 0 then
    world.spawnItem({name="money", count=storage.pixels}, entity.position())
    storage.pixels  = 0        
  else
    animator.playSound("error")
  end
end