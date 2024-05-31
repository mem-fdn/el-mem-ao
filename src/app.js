import express from "express";
import cron from "node-cron";
import { EL_LIST } from "./utils/ao-list.js";
import { loadIntoAo } from "./utils/ao.js";

const app = express();
const PORT = process.env.PORT || 3000;

// Example route
app.get("/", (req, res) => {
  res.send({ status: "running" });
});

// Schedule a cron job to run every minute
cron.schedule("* * * * *", async () => {
  try {
    for (const el of EL_LIST) {
      console.log(el);
      await loadIntoAo(el.ao_pid, el.mem_id, el.loadFunction);
    }
  } catch (error) {
    console.error("Error making API call:", error);
  }
});

app.listen(PORT, () => {
  console.log(`[⚡️] Server running at: ${PORT}`);
});
