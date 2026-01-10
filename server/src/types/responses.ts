import { getMessages } from "../services/message";

export type ResMessage = Awaited<ReturnType<typeof getMessages>>[number];
