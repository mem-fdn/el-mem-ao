<p align="center">
  <a href="https://mem.tech">
    <img src="https://github.com/decentldotland/MEM/assets/77340894/d840ef84-540f-4ccc-a7e0-1ed03c4af8dd" height="180">
  </a>
  <h3 align="center"><code>@mem-fdn/el-mem-ao</code></h3>
  <p align="center">MEM-AO data pipeline/p>
</p>

## Abstract
Extract-Load data pipeline from MEM to AO.

## Build & Run

```bash
git pull https://github.com/mem-fdn/el-mem-ao.git

cd el-mem-ao

npm i && npm run start
```
## Register a MEM Function
To register a MEM function within this node and include it within the EL job, you need to create a PR adding the following:

### Add your `receiver` AO process

You have the freedom to manage the logic of how you want your MEM data to be loaded in AO, and in which format and structure. However, ensure that your L`oad*` handler is gated by the admin address listed below, and that you have a `State` table. The AO process source code should be added to the [./ao-processes](./ao-processes) directory.

```lua
--[[
  internal state
]]
--
State = State or {};
Admin = Admin or "aP7IWOaR5wW02BpH4-s5wRsrCsmfI4XhoW2JmPo5GwU";
```

And here’s how your main Load handler can be gated:

```lua
if msg.From == Admin then
    -- code logic here
    end
```

### Register your receiver

in the [`./src/utils/ao-list`](./src/utils/ao-list.js) file, add a new object as follow:

```json
{
  "ao_pid": "RECEIVER_ID",
  "mem_id": "MEM_DATA_SOURCE_ID",
  "loadFunction": "RECEIVER_LOAD_HANDLER_NAME"
}
```

And after that you can create a PR!

## License
This project is licensed under the [MIT License](./LICENSE)