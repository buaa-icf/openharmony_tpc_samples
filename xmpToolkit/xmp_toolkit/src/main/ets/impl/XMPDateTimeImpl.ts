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

import XMPDateTime from '../XMPDateTime';
import XMPError from '../XMPError';
import XMPException from '../XMPException';
import ISO8601Converter from './ISO8601Converter';
import {TimeZone} from '../XMPDateTimeFactory';

/**
 * XMPDateTime接口的实现。内部使用Date对象和额外的纳秒字段，因为Date对象只支持毫秒精度。
 * nanoSeconds仅用于表示毫秒以上的精度。
 */
export default class XMPDateTimeImpl implements XMPDateTime {
    /** 年份 */
    private year: number = 0;
    /** 月份 */
    private month: number = 0;
    /** 日期 */
    private day: number = 0;
    /** 小时 */
    private hour: number = 0;
    /** 分钟 */
    private minute: number = 0;
    /** 秒 */
    private second: number = 0;
    /** 时区 */
    private timeZone: TimeZone = { timeZone: "" };
    /** 时区偏移（毫秒） - 正数表示东时区（UTC+），负数表示西时区（UTC-）*/
    private timeZoneOffset: number = 0;
    /** 纳秒，包含微秒和纳秒 */
    private nanoSeconds: number = 0;
    /** 是否有日期部分 */
    private mHasDate: boolean = false;
    /** 是否有时间部分 */
    private mHasTime: boolean = false;
    /** 是否有时区信息 */
    private mHasTimeZone: boolean = false;

    /**
     * 创建一个XMPDateTime实例，使用当前时间和默认时区
     */
    constructor();

    /**
     * 从Date对象创建XMPDateTime实例
     * @param date Date对象
     */
    constructor(date: Date);

    /**
     * 从ISO 8601字符串创建XMPDateTime实例
     * @param strValue ISO 8601字符串
     */
    constructor(strValue: string);

    /**
     * 构造函数实现
     */
    constructor(param?: Date | string) {
        if (param instanceof Date) {
            // 从Date对象初始化
            const date = param;
            this.year = date.getFullYear();
            this.month = date.getMonth() + 1;
            this.day = date.getDate();
            this.hour = date.getHours();
            this.minute = date.getMinutes();
            this.second = date.getSeconds();
            this.nanoSeconds = date.getMilliseconds() * 1000000;

            // Date.getTimezoneOffset() 返回本地时间与UTC的分钟差
            // timeZoneOffset = +28800000 (8小时)
            this.timeZoneOffset = -date.getTimezoneOffset() * 60 * 1000;

            // 对象包含所有日期组件
            this.mHasDate = this.mHasTime = this.mHasTimeZone = true;
        } else if (typeof param === 'string') {
            try {
                ISO8601Converter.parseWithDateTime(param, this);
            } catch (e) {
                throw new XMPException('Invalid ISO 8601 date string', XMPError.BADVALUE);
            }
        }
    }

    /**
     * @see XMPDateTime#getYear()
     */
    public getYear(): number {
        return this.year;
    }

    /**
     * @see XMPDateTime#setYear(int)
     */
    public setYear(year: number): void {
        // 支持负年份，但限制绝对值在 9999 以内
        const absYear: number = Math.abs(year);
        this.year = year < 0 ? -Math.min(absYear, 9999) : Math.min(absYear, 9999);
        this.mHasDate = true;
    }

    /**
     * @see XMPDateTime#getMonth()
     */
    public getMonth(): number {
        return this.month;
    }

    /**
     * @see XMPDateTime#setMonth(int)
     */
    public setMonth(month: number): void {
        if (month < 1) {
            this.month = 0; // 0 或负数表示未设置
        } else if (month > 12) {
            this.month = 12;
        } else {
            this.month = month;
        }
        this.mHasDate = true;
    }

    /**
     * @see XMPDateTime#getDay()
     */
    public getDay(): number {
        return this.day;
    }

    /**
     * @see XMPDateTime#setDay(int)
     */
    public setDay(day: number): void {
        if (day < 1) {
            this.day = 0; // 0 或负数表示未设置
        } else if (day > 31) {
            this.day = 31;
        } else {
            this.day = day;
        }
        this.mHasDate = true;
    }

    /**
     * @see XMPDateTime#getHour()
     */
    public getHour(): number {
        return this.hour;
    }

    /**
     * 更新 hasTime 标志，基于所有时间字段的值
     */
    private updateHasTime(): void {
        // 只有当至少有一个时间字段非零时才设置 hasTime
        this.mHasTime = (this.hour !== 0 || this.minute !== 0 || this.second !== 0 || this.nanoSeconds !== 0);
    }

    /**
     * @see XMPDateTime#setHour(int)
     */
    public setHour(hour: number): void {
        this.hour = Math.min(Math.abs(hour), 23);
        this.updateHasTime();
    }

    /**
     * @see XMPDateTime#getMinute()
     */
    public getMinute(): number {
        return this.minute;
    }

    /**
     * @see XMPDateTime#setMinute(int)
     */
    public setMinute(minute: number): void {
        this.minute = Math.min(Math.abs(minute), 59);
        this.updateHasTime();
    }

    /**
     * @see XMPDateTime#getSecond()
     */
    public getSecond(): number {
        return this.second;
    }

    /**
     * @see XMPDateTime#setSecond(int)
     */
    public setSecond(second: number): void {
        this.second = Math.min(Math.abs(second), 59);
        this.updateHasTime();
    }

    /**
     * @see XMPDateTime#getNanoSecond()
     */
    public getNanoSecond(): number {
        return this.nanoSeconds;
    }

    /**
     * @see XMPDateTime#setNanoSecond(int)
     */
    public setNanoSecond(nanoSecond: number): void {
        this.nanoSeconds = nanoSecond;
        this.updateHasTime();
    }

    /**
     * 比较两个日期时间对象
     * @param dt 要比较的XMPDateTime对象
     * @return 比较结果
     */
    public compareTo(dt: XMPDateTime): number {
        const thisCalendar: Date = this.getCalendar();
        const dtCalendar: Date = dt.getCalendar();

        let d: number = thisCalendar.getTime() - dtCalendar.getTime();

        if (d !== 0) {
            return Math.sign(d);
        } else {
            // 如果毫秒数相等，比较纳秒数
            d = this.nanoSeconds - dt.getNanoSecond();
            return Math.sign(d);
        }
    }

    /**
     * @see XMPDateTime#getTimeZone()
     */
    public getTimeZone(): string
    {
        return this.timeZone.timeZone;
    }

    /**
     * @see XMPDateTime#setTimeZone(TimeZone)
     */
    public setTimeZone(tzStr: string): void
    {
        this.timeZone.timeZone = tzStr;
        this.mHasTimeZone = true;


        // 根据时区字符串设置时区偏移
        if (tzStr === "UTC") {
            this.timeZoneOffset = 0;
        } else {
            this.timeZoneOffset = -new Date().getTimezoneOffset() * 60 * 1000;
        }
    }

    /**
     * 获取时区偏移（毫秒）
     * @return 时区偏移（毫秒）
     */
    public getTimeZoneOffset(): number {
        return this.timeZoneOffset;
    }

    /**
     * 设置时区偏移（毫秒）
     * @param offset 时区偏移（毫秒）
     */
    public setTimeZoneOffset(offset: number): void {
        this.timeZoneOffset = offset;
        this.mHasTimeZone = true;
    }

    /**
     * @see XMPDateTime#mHasDate()
     */
    public hasDate(): boolean {
        return this.mHasDate;
    }

    /**
     * @see XMPDateTime#mHasTime()
     */
    public hasTime(): boolean {
        return this.mHasTime;
    }

    /**
     * @see XMPDateTime#mHasTimeZone()
     */
    public hasTimeZone(): boolean {
        return this.mHasTimeZone;
    }

    /**
     * @see XMPDateTime#getCalendar()
     */
    public getCalendar(): Date {
        // 创建一个表示本地时间的Date对象（基于当前的时区设置）
        const date = new Date();

        // 使用Date.UTC创建UTC时间，然后根据时区偏移调整
        const utcTime = Date.UTC(
            this.year,
            this.month - 1,
            this.day,
            this.hour,
            this.minute,
            this.second,
            Math.floor(this.nanoSeconds / 1000000)
        );

        // 如果有时区信息，需要调整
        if (this.mHasTimeZone && this.timeZoneOffset !== 0) {
            const adjustedTime = utcTime - this.timeZoneOffset;
            date.setTime(adjustedTime);
        } else {
            // 没有时区信息，直接使用UTC时间
            date.setTime(utcTime);
        }

        return date;
    }

    /**
     * @see XMPDateTime#getISO8601String()
     */
    public getISO8601String(): string {
        return ISO8601Converter.render(this);
    }

    /**
     * @return 返回ISO字符串表示
     */
    public toString(): string {
        return this.getISO8601String();
    }
}