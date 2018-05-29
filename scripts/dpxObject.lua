require "/scripts/util.lua"

dpx = {}

function dpx.init()
  dpx.ALL = math.huge -- 1 EdPx,likely more than will ever excist 

  storage.dpx = storage.dpx or config.getParameter("initialDpx", 0)

  dpx.maxStore = config.getParameter("dpx.maxStore", dpx.ALL)
  dpx.maxOutput = config.getParameter("dpx.maxOutput", dpx.ALL)

  dpx.inputNodes = config.getParameter("dpx.inputNodes", {})
  dpx.outputNodes = config.getParameter("dpx.outputNodes", {})

  dpx.getNodes()
  message.setHandler("dpxRequest", dpx.handleRequest)
  message.setHandler("dpxReply", dpx.handleReply)
end

------------------------------------------------------------------------------------------------------------------------

function dpx.generate(amount)
  storage.dpx = storage.dpx + amount

  -- now ensure value is valid

  local stored = amount
  if storage.dpx > dpx.maxStore and dpx.maxStore >= 0 then -- ensure not greater than max
    overflow = amount - (dpx.maxStore - storage.dpx)
    storage.dpx = dpx.maxStore
  elseif storage.dpx < 0 then -- ensure not negative
    storage.dpx = 0
  end

  storage.dpx = math.floor(storage.dpx) -- ensure an intager
  return stored
end

function dpx.consume(amount)
  return dpx.generate(-amount)
end

------------------------------------------------------------------------------------------------------------------------

function dpx.sendRequest(targetEntityID, node, amount)
  world.sendEntityMessage(targetEntityID, "dpxRequest", entity.id(), node, amount)
  --sb.logInfo(entity.id() .. " requesting " .. amount .. " from " .. targetEntityID .. " on node " .. node)
end

function dpx.handleRequest(requestStr, isLocal, sourceEntityID, node, amount) -- Can be overridden for specific control
  local output = 0
  if amount > 0 and contains(dpx.outputNodes, node) then
    output = math.min(amount, storage.dpx, dpx.maxOutput / config.getParameter("scriptDelta", 20))
  end
  
  dpx.consume(output)

  world.sendEntityMessage(sourceEntityID, "dpxReply", output)

end

function dpx.handleReply(requestStr, isLocal, amount) -- Can be over ridden for specific control
  dpx.generate(amount)
end

------------------------------------------------------------------------------------------------------------------------

function dpx.getNodes()
  local nodes = {}
  for i, inode in ipairs(dpx.inputNodes) do -- dpx nodes
    for id, onode in pairs(object.getInputNodeIds(inode)) do -- connected objects
      nodes[id] = onode
    end
  end
  self.dpxInputConnections = nodes
  return nodes
end

function onNodeConnectionChange()
  dpx.getNodes()
end