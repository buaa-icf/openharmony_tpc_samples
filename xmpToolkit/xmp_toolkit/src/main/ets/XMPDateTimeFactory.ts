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

import XMPDateTime  from './XMPDateTime';
import XMPException from './XMPException';
import XMPDateTimeImpl from './impl/XMPDateTimeImpl';

/**
 * A factory to create <code>XMPDateTime</code>-instances from a <code>Calendar</code> or an
 * ISO 8601 string or for the current time.
 */
export interface TimeZone {
    timeZone: string;
}

export default  class XMPDateTimeFactory {
    /** The UTC TimeZone */
    private static readonly UTC: TimeZone = { timeZone: 'UTC' };

    /**
     * Creates an <code>XMPDateTime</code> from a <code>Calendar</code>-object.
     * 
     * @param calendar a <code>Calendar</code>-object.
     * @return An <code>XMPDateTime</code>-object.
     */
    public static createFromCalendar(calendar: ESObject): XMPDateTime {
        return new XMPDateTimeImpl(calendar);
    }

    /**
     * Creates an empty <code>XMPDateTime</code>-object.
     * @return Returns an <code>XMPDateTime</code>-object.
     */
    public static createEmpty(): XMPDateTime {
        return new XMPDateTimeImpl();
    }

    /**
     * Creates an <code>XMPDateTime</code>-object from initial values.
     * @param year years
     * @param month months from 1 to 12<br>
     * <em>Note:</em> Remember that the month in {@link Calendar} is defined from 0 to 11.
     * @param day days
     * @return Returns an <code>XMPDateTime</code>-object.
     */
    public static createDate(year: number, month: number, day: number): XMPDateTime {
        const dt: XMPDateTime = new XMPDateTimeImpl();
        dt.setYear(year);
        dt.setMonth(month);
        dt.setDay(day);
        return dt;
    }

    /**
     * Creates an <code>XMPDateTime</code>-object from initial values.
     * @param year years
     * @param month months from 1 to 12<br>
     * <em>Note:</em> Remember that the month in {@link Calendar} is defined from 0 to 11.
     * @param day days
     * @param hour hours
     * @param minute minutes
     * @param second seconds
     * @param nanoSecond nanoseconds 
     * @return Returns an <code>XMPDateTime</code>-object.
     */
    public static create(year: number, month: number, day: number, 
        hour: number, minute: number, second: number, nanoSecond: number): XMPDateTime {
        const dt: XMPDateTime = new XMPDateTimeImpl();
        dt.setYear(year);
        dt.setMonth(month);
        dt.setDay(day);
        dt.setHour(hour);
        dt.setMinute(minute);
        dt.setSecond(second);
        dt.setNanoSecond(nanoSecond);
        return dt;
    }

    /**
     * Creates an <code>XMPDateTime</code> from an ISO 8601 string.
     * 
     * @param strValue The ISO 8601 string representation of the date/time.
     * @return An <code>XMPDateTime</code>-object.
     * @throws XMPException When the ISO 8601 string is non-conform
     */
    public static createFromISO8601(strValue: string): XMPDateTime {
        return new XMPDateTimeImpl(strValue);
    }

    /**
     * Obtain the current date and time.
     * 
     * @return Returns The returned time is UTC, properly adjusted for the local time zone. The
     *         resolution of the time is not guaranteed to be finer than seconds.
     */
    public static getCurrentDateTime(): XMPDateTime {
        const now = new Date();
        const dateTime = new XMPDateTimeImpl(now);
        return dateTime;
    }

    /**
     * Sets the local time zone without touching any other Any existing time zone value is replaced,
     * the other date/time fields are not adjusted in any way.
     * 
     * @param dateTime the <code>XMPDateTime</code> variable containing the value to be modified.
     * @return Returns an updated <code>XMPDateTime</code>-object.
     */
    public static setLocalTimeZone(dateTime: XMPDateTime): XMPDateTime {
        const result = new XMPDateTimeImpl();

        // 复制所有时间字段
        result.setYear(dateTime.getYear());
        result.setMonth(dateTime.getMonth());
        result.setDay(dateTime.getDay());
        result.setHour(dateTime.getHour());
        result.setMinute(dateTime.getMinute());
        result.setSecond(dateTime.getSecond());
        result.setNanoSecond(dateTime.getNanoSecond());

        // 获取本地时区偏移
        const now = new Date();
        const localOffset = -now.getTimezoneOffset() * 60 * 1000; // 转换为毫秒

        // 设置本地时区偏移
        result.setTimeZoneOffset(localOffset);

        // 设置时区字符串
        const offsetHours = Math.abs(Math.floor(localOffset / (60 * 60 * 1000)));
        const offsetMinutes = Math.abs(Math.floor((localOffset % (60 * 60 * 1000)) / (60 * 1000)));
        const sign = localOffset >= 0 ? '+' : '-';
        result.setTimeZone(`UTC${sign}${offsetHours.toString().padStart(2, '0')}:${offsetMinutes.toString().padStart(2, '0')}`);

        return result;
    }

    /**
     * Make sure a time is UTC. If the time zone is not UTC, the time is
     * adjusted and the time zone set to be UTC.
     *
     * @param dateTime
    *            the <code>XMPDateTime</code> variable containing the time to
     *            be modified.
     * @return Returns an updated <code>XMPDateTime</code>-object.
     */
    public static convertToUTCTime(dateTime: XMPDateTime): XMPDateTime {
        const isoString = dateTime.getISO8601String();

        // 使用Date对象解析ISO字符串
        const date = new Date(isoString);

        // 获取UTC时间的各个分量
        const utcYear = date.getUTCFullYear();
        const utcMonth = date.getUTCMonth() + 1;
        const utcDay = date.getUTCDate();
        const utcHour = date.getUTCHours();
        const utcMinute = date.getUTCMinutes();
        const utcSecond = date.getUTCSeconds();
        const utcMillisecond = date.getUTCMilliseconds();

        // 创建UTC时间的XMPDateTime
        const utcDateTime = new XMPDateTimeImpl();
        utcDateTime.setYear(utcYear);
        utcDateTime.setMonth(utcMonth);
        utcDateTime.setDay(utcDay);
        utcDateTime.setHour(utcHour);
        utcDateTime.setMinute(utcMinute);
        utcDateTime.setSecond(utcSecond);
        utcDateTime.setNanoSecond(utcMillisecond * 1000000);
        utcDateTime.setTimeZoneOffset(0);

        return utcDateTime;
    }

    /**
     * Make sure a time is local. If the time zone is not the local zone, the time is adjusted and
     * the time zone set to be local.
     *
     * @param dateTime the <code>XMPDateTime</code> variable containing the time to be modified.
     * @return Returns an updated <code>XMPDateTime</code>-object.
     */
    public static convertToLocalTime(dateTime: XMPDateTime): XMPDateTime {
        const isoString = dateTime.getISO8601String();

        // 使用Date对象解析ISO字符串
        const date = new Date(isoString);

        // 获取本地时间的各个分量
        const localYear = date.getFullYear();
        const localMonth = date.getMonth() + 1;
        const localDay = date.getDate();
        const localHour = date.getHours();
        const localMinute = date.getMinutes();
        const localSecond = date.getSeconds();
        const localMillisecond = date.getMilliseconds();

        // 创建本地时间的XMPDateTime
        const localDateTime = new XMPDateTimeImpl();
        localDateTime.setYear(localYear);
        localDateTime.setMonth(localMonth);
        localDateTime.setDay(localDay);
        localDateTime.setHour(localHour);
        localDateTime.setMinute(localMinute);
        localDateTime.setSecond(localSecond);
        localDateTime.setNanoSecond(localMillisecond * 1000000);

        // 设置本地时区偏移
        const localOffset = -new Date().getTimezoneOffset() * 60 * 1000;
        localDateTime.setTimeZoneOffset(localOffset);

        return localDateTime;
    }
}