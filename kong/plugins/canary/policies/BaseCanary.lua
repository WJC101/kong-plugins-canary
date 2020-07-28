---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Rao xiao'yan.
--- DateTime: 2020/2/26 16:05
---
local BaseCanary = {};
function BaseCanary:new(o, name, conf)
  o = o or {}
  setmetatable(o, self);
  self.__index = self;
  self.conf = conf;
  self.name = name;
  return o;
end

function BaseCanary:validate()
  return true, nil;
end

function BaseCanary:get_upstream()
  return self.conf.canary_upstream;
end

function BaseCanary:handler(fallback)
  local validate, policy_canary = self:validate();

  -- false fallback default upstream
  if not validate then
    fallback();
    return 'fallback', policy_canary
  end
  -- uid upstream is not nil
  local _upstream = self:get_upstream()
  if policy_canary and _upstream then
    kong.service.set_upstream(_upstream)
    kong.log.notice('Canary policy is ', policy_canary, ',canary upstream:', _upstream);
    return 'end', policy_canary
  end
  return 'next', policy_canary
end

return BaseCanary;