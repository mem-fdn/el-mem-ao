--[[
    Imports
]] --

local json = require("json")
local ao = require("ao")

--[[
  This module implements the Census Surveys Protocol on ao

  Terms:
    Sender: the wallet or Process that sent the Message

  It will first initialize the internal state, define utils code blocks and then attach handlers.

    - Info(): return process metadata: Name.

    - GetState(): getter -- return the table of State.

    - ResolveDomain(PrimaryDomain: string): return the address of a given domain.

    - ResolveAddress(Address: String): return the primay domain of a given address.

    - loadAnsState(Data: String): load the ANS state into the State table. Admin gated function.
]]
--

--[[
  internal state
]]
--
State = State or {}
Name = Name or "EL-ANS-AO"
Admin = Admin or "aP7IWOaR5wW02BpH4-s5wRsrCsmfI4XhoW2JmPo5GwU"

--[[
  utils helper functions
]]
--

-- Function to get the address for a given primary domain from the State table
local function get_address_by_primary_domain(primary_domain)
    for _, item in ipairs(State) do
        if item.primary_domain == primary_domain then
            return item.address
        end
    end
    return nil -- Return nil if the primary domain is not found
end

-- Function to get the primary domain for a given address from the State table
local function get_primary_domain_by_address(address)
    for _, item in ipairs(State) do
        if item.address == address then
            print(item.primary_domain)
            return item.primary_domain
        end
    end
    return nil -- Return nil if the address is not found
end

--[[
     Add handlers for each incoming Action
   ]]
--

--[[
     Info
   ]]
--
Handlers.add(
    "info",
    Handlers.utils.hasMatchingTag("Action", "Info"),
    function(msg)
        ao.send(
            {
                Target = msg.From,
                Tags = {
                    Name = Name
                }
            }
        )
    end
)

--[[
     GetState
   ]]
--
Handlers.add(
    "getState",
    Handlers.utils.hasMatchingTag("Action", "GetState"),
    function(msg)
        ao.send(
            {
                Target = msg.From,
                Data = json.encode(State)
            }
        )
    end
)

--[[
     ResolveDomain
   ]]
--
Handlers.add(
    "resolveDomain",
    Handlers.utils.hasMatchingTag("Action", "ResolveDomain"),
    function(msg)
        assert(type(msg.PrimaryDomain) == "string", "err_domain_required")
        local address = get_address_by_primary_domain(msg.PrimaryDomain)
        ao.send(
            {
                Target = msg.From,
                Tags = {
                    Address = address
                }
            }
        )
    end
)

--[[
     ResolveAddress
   ]]
--
Handlers.add(
    "resolveAddress",
    Handlers.utils.hasMatchingTag("Action", "ResolveAddress"),
    function(msg)
        assert(type(msg.Address) == "string", "err_address_required")
        local domain = get_primary_domain_by_address(msg.Address)
        ao.send(
            {
                Target = msg.From,
                Tags = {
                    Domain = domain
                }
            }
        )
    end
)
--[[
     LoadAnsState
   ]]
--
Handlers.add(
    "loadAnsState",
    Handlers.utils.hasMatchingTag("Action", "LoadAnsState"),
    function(msg)
        local caller = msg.From
        local mem_data = json.decode(msg.Data)
        assert(type(msg.Data) == "string", "err_invalid_data_type")

        if msg.From == Admin then
            for _, balance in ipairs(mem_data.balances) do
                table.insert(
                    State,
                    {
                        address = balance.address,
                        primary_domain = balance.primary_domain
                    }
                )
            end

            ao.send(
                {
                    Target = msg.From,
                    Tags = {
                        Action = "ANS-State-Loaded"
                    }
                }
            )
        end
    end
)
