// dist/awesome_datetime.d.ts

export interface AwesomeDateTimeOptions {
  dtString: string;
}

export interface DateDiffResult {
  // NOTE: this mirrors whatever AgeCalculator.dateDifference(...).toJson()
  // actually produces in date_calculator.dart. Fill in real fields —
  // this is a placeholder shape based on typical date-diff output.
  years?: number;
  months?: number;
  days?: number;
  hours?: number;
  minutes?: number;
  seconds?: number;
  [key: string]: unknown;
}

export declare class AwesomeDateTime {
  constructor(options: AwesomeDateTimeOptions);

  /** Formats the current stored instant as UTC, e.g. "02 Aug 2026 30:15" (mm:HH). */
  toUTCTime(): string;

  /**
   * Formats the current stored instant as local time.
   * If the instance isn't timezone-aware yet, this implicitly calls
   * setTimeZone(getLocalOffset()) first — so it never throws, unlike
   * the underlying Dart method's original "Naive Datetime" behavior.
   */
  toLocalTime(): string;

  /**
   * Applies a fixed UTC offset, e.g. "+05:30" or "-08:00".
   * Throws if the offset string is malformed or out of range
   * (hours 0-14, minutes 0-59).
   */
  setTimeZone(tz: string): void;

  /** Returns the host machine's current UTC offset, e.g. "+05:30". */
  getLocalOffset(): string;

  /** Whether a timezone offset has been applied to this instance. */
  isTzAware(): boolean;
}

export declare namespace AwesomeDateTime {
  /**
   * Static helper — computes the difference between two ISO date strings.
   * NOTE: this static method isn't currently wired up in your JS bindings
   * (web/main.dart only exposes it on the Dart side, not via
   * globalContext.setProperty). See note below.
   */
  function dateDiff(fromDate: string, toDate: string): DateDiffResult;
}

declare global {
  interface Window {
    AwesomeDateTime: typeof AwesomeDateTime;
  }
}