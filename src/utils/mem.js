import axios from "axios";

export async function readMemState(id) {
  try {
    const state = (await axios.get(`https://api.mem.tech/api/state/${id}`))
      ?.data;
    return state;
  } catch (err) {
    return err;
  }
}
