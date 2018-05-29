require "/scripts/dpxObject.lua"

function init()
  object.setInteractive(true)
  dpx.init()

end

function update(dt)
  animator.setAnimationState("meterLevel", tostring(math.floor( storage.dpx/dpx.maxStore * 10))) -- Set sanimation state 0-10  

  if storage.dpx < dpx.maxStore then -- ensure we dont just eat power
    for id, node in pairs(self.dpxInputConnections) do
      dpx.sendRequest(id, node, dpx.ALL)
    end
  end

  if storage.dpx > 0 then
    object.setOutputNodeLevel(0, true)
  else
    object.setOutputNodeLevel(0, false)
  end

end

function onInteraction(args)
  object.say(tostring(storage.dpx) ..  "/" .. dpx.maxStore .. " dPx")
end



