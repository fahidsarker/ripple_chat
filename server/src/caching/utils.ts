type DURATION_UNIT =
  | "millisecs"
  | "secs"
  | "mins"
  | "hours"
  | "days"
  | "weeks"
  | "months"
  | "years";
export type StrDuration = `${number} ${DURATION_UNIT}`;

// returns in millisec
export const parseDuration = (duration: StrDuration) => {
  const [value, unit] = duration.split(" ");
  const valueNum = parseInt(value);
  if (isNaN(valueNum)) throw new Error("Invalid duration");

  switch (unit) {
    case "millisec":
      return valueNum;
    case "secs":
      return valueNum * 1000;
    case "mins":
      return valueNum * 1000 * 60;
    case "hours":
      return valueNum * 1000 * 60 * 60;
    case "days":
      return valueNum * 1000 * 60 * 60 * 24;
    case "weeks":
      return valueNum * 1000 * 60 * 60 * 24 * 7;
    case "months":
      return valueNum * 1000 * 60 * 60 * 24 * 30;
    case "years":
      return valueNum * 1000 * 60 * 60 * 24 * 365;
    default:
      throw new Error("Invalid duration");
  }
};
