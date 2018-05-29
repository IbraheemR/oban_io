-- require "/scripts/dpxObject.lua" -- We dont need any of this functionality, only a simple hoosk needs to be writeen as below

function init()
  message.setHandler("dpxRequest", handleRequest)
  object.setOutputNodeLevel(0, true)
end

function handleRequest(requestStr, isLocal, sourceEntityID, node, amount)
  world.sendEntityMessage(sourceEntityID, "dpxReply", amount) -- Constantly reply with specified amount
end

