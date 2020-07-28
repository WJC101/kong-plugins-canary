---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Rao xiao'yan.
--- DateTime: 2020/2/21 10:18
---

local policies = require "kong.plugins.canary.policies"
local cjson = require "cjson"
local CanaryHandler = {}

CanaryHandler.PRORITY = 899
CanaryHandler.VERSION = "0.0.1"

local function fallback()
  kong.log.notice('fallback');
end

local types = { 'ip', 'uid', 'customize', 'default' };

function CanaryHandler:access(conf)
  local result = nil;
  local policy_canary = nil;
  local canarys = {};
  for _, type in pairs(types) do
    local policy = policies[type];
    if policy then
      result, policy_canary = policy.handler(fallback, conf);
      if policy_canary then
        table.insert(canarys, policy_canary);
      end
      kong.log.notice('canary type is ', type, ',handler result:', result)
      if result == 'fallback' or result == 'end' then
        kong.log.notice('canary rule:', cjson.encode(canarys), ',canary result:', result)
        return
      end
    end
  end

end

return CanaryHandler;