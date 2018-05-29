require "/scripts/dpxObject.lua"

function init()
  object.setInteractive(true)
  dpx.init()
end

function update(dt)
  if animator.animationState("crankState") == "idle" then
    object.setOutputNodeLevel(0, false)
  end
end

function onInteraction(args)
  if animator.animationState("crankState") == "idle" then
    animator.setAnimationState("crankState", "active")
    object.setOutputNodeLevel(0, true)
    dpx.generate(config.getParameter("dpx.generation", 20))
  end
end