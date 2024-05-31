import { createDataItemSigner, message, dryrun } from "@permaweb/aoconnect";
import dotenv from "dotenv";
import { readMemState } from "./mem.js";
dotenv.config();

const wallet = JSON.parse(process.env.JWK);

export async function loadIntoAo(pid, mid, handler) {
  try {
    const data = JSON.stringify(await readMemState(mid));
    const messageId = await message({
      process: pid,
      signer: createDataItemSigner(wallet),
      data: data,
      tags: [{ name: "Action", value: handler }],
    });

    console.log(`Load mid: ${messageId}`);
    return { messageId };
  } catch (error) {
    console.log(error);
    return { messageId: false };
  }
}
