import { Request, Response, NextFunction } from "express";
import { Res } from "./response";

export type CKExpressHandler = (
  req: Request,
  res: Response
) => Promise<Res> | Res;

export function apiHandler(fn: CKExpressHandler) {
  return async (req: Request, res: Response, next: NextFunction) => {
    try {
      const response = await fn(req, res);
      return response.handle(req, res);
    } catch (err) {
      next(err);
    }
  };
}
