import { queryChats } from "../services/chat";
import { getMessages } from "../services/message";

export type ResMessage = Awaited<ReturnType<typeof getMessages>>[number];
export type ResChat = Awaited<ReturnType<typeof queryChats>>[number];
