/*
Copyright (c) 2026 Huawei Device Co., Ltd.
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

/**
 * The <code>XMPDateTime</code>-class represents a point in time up to a resolution of nano
 * seconds. Dates and time in the serialized XMP are ISO 8601 strings. There are utility functions
 * to convert to the ISO format, a <code>Calendar</code> or get the Timezone. The fields of
 * <code>XMPDateTime</code> are:
 * <ul>
 * <li> month - The month in the range 1..12.
 * <li> day - The day of the month in the range 1..31.
 * <li> minute - The minute in the range 0..59.
 * <li> hour - The time zone hour in the range 0..23.
 * <li> minute - The time zone minute in the range 0..59.
 * <li> nanoSecond - The nano seconds within a second. <em>Note:</em> if the XMPDateTime is
 * converted into a calendar, the resolution is reduced to milli seconds.
 * <li> timeZone - a <code>TimeZone</code>-object.
 * </ul>
 * DateTime values are occasionally used in cases with only a date or only a time component. A date
 * without a time has zeros for all the time fields. A time without a date has zeros for all date
 * fields (year, month, and day).
 */
import {TimeZone} from './XMPDateTimeFactory';

export default interface XMPDateTime {
    /** @return Returns the year, can be negative. */
    getYear(): number;
    
    /** @param year Sets the year */
    setYear(year: number): void;

    /** @return Returns The month in the range 1..12. */
    getMonth(): number;

    /** @param month Sets the month 1..12 */
    setMonth(month: number): void;
    
    /** @return Returns the day of the month in the range 1..31. */
    getDay(): number;
    
    /** @param day Sets the day 1..31 */
    setDay(day: number): void;

    /** @return Returns hour - The hour in the range 0..23. */
    getHour(): number;

    /** @param hour Sets the hour in the range 0..23. */
    setHour(hour: number): void;
    
    /** @return Returns the minute in the range 0..59. */ 
    getMinute(): number;

    /** @param minute Sets the minute in the range 0..59. */
    setMinute(minute: number): void;
    
    /** @return Returns the second in the range 0..59. */
    getSecond(): number;

    /** @param second Sets the second in the range 0..59. */
    setSecond(second: number): void;
    
    /**
     * @return Returns milli-, micro- and nano seconds.
     * 		   Nanoseconds within a second, often left as zero?
     */
    getNanoSecond(): number;

    /**
     * @param nanoSecond Sets the milli-, micro- and nano seconds.
     *		Granularity goes down to milli seconds. 		   
     */
    setNanoSecond(nanoSecond: number): void;

    /** @return Returns the time zone. */
    getTimeZone(): string;

    /** @param tz a time zone to set */
    setTimeZone(tzStr: string): void;
    
    /** @return Returns the time zone. */
    /**
     * 获取时区偏移（毫秒）
     * @return 时区偏移（毫秒）
     */
    getTimeZoneOffset(): number;

    /** @param tz a time zone to set */
    setTimeZoneOffset(offset: number): void;
    
    /**
     * This flag is set either by parsing or by setting year, month or day. 
     * @return Returns true if the XMPDateTime object has a date portion.
     */
    hasDate(): boolean;
    
    /**
     * This flag is set either by parsing or by setting hours, minutes, seconds or milliseconds. 
     * @return Returns true if the XMPDateTime object has a time portion.
     */
    hasTime(): boolean;
    
    /**
     * This flag is set either by parsing or by setting hours, minutes, seconds or milliseconds. 
     * @return Returns true if the XMPDateTime object has a defined timezone.
     */
    hasTimeZone(): boolean;
    
    /** 
     * @return Returns a <code>Calendar</code> (only with milli second precision). <br>
     *  		<em>Note:</em> the dates before Oct 15th 1585 (which normally fall into validity of 
     *  		the Julian calendar) are also rendered internally as Gregorian dates. 
     */
    getCalendar(): ESObject;
    
    /**
     * @return Returns the ISO 8601 string representation of the date and time.
     */
    getISO8601String(): string;
}
