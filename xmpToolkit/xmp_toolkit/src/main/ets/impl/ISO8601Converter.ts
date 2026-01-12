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
import XMPDateTimeImpl from './XMPDateTimeImpl';

/**
 * 在ISO 8601字符串和XMPDateTime对象之间进行转换，支持毫秒精度
 */
export default class ISO8601Converter {
    /**
     * 私有构造函数
     */
    private constructor() {
        // 空构造函数
    }
    
    /**
     * 将ISO 8601字符串转换为XMPDateTime对象
     * 
     * 根据ISO 8601和http://www.w3.org/TR/NOTE-datetime解析日期：
     * <ul>
     * <li>YYYY</li>
     * <li>YYYY-MM</li>
     * <li>YYYY-MM-DD</li>
     * <li>YYYY-MM-DDThh:mmTZD</li>
     * <li>YYYY-MM-DDThh:mm:ssTZD</li>
     * <li>YYYY-MM-DDThh:mm:ss.sTZD</li>
     * </ul>
     * 
     * 数据字段：
     * <ul>
     * <li>YYYY = 四位数年份</li>
     * <li>MM = 两位数月份（01=1月，依此类推）</li>
     * <li>DD = 两位数日期（01至31）</li>
     * <li>hh = 两位数小时（00至23）</li>
     * <li>mm = 两位数分钟（00至59）</li>
     * <li>ss = 两位数秒（00至59）</li>
     * <li>s = 一个或多个表示秒的小数部分的数字</li>
     * <li>TZD = 时区指示符（Z或+hh:mm或-hh:mm）</li>
     * </ul>
     * 
     * 注意：ISO 8601似乎不允许小于1000或大于9999的年份。我们允许任何年份，甚至负数。年份格式为"%.4d"。
     * 
     * @param iso8601String 符合ISO 8601的日期字符串
     * @return 返回XMPDateTime对象
     * @throws XMPException 当字符串不符合格式时抛出
     */
    public static parse(iso8601String: string): XMPDateTime {
        return ISO8601Converter.parseWithDateTime(iso8601String, new XMPDateTimeImpl());
    }
    
    /**
     * @param iso8601String 符合ISO 8601的日期字符串
     * @param binValue 一个现有的XMPDateTime对象，将用解析的日期设置
     * @return 返回包含ISO8601日期的XMPDateTime对象
     * @throws XMPException 当字符串不符合格式时抛出
     */
    public static parseWithDateTime(iso8601String: string, binValue: XMPDateTime): XMPDateTime {
        if (iso8601String == null) {
            throw new XMPException("Parameter must not be null", XMPError.BADPARAM);
        } else if (iso8601String.length === 0) {
            return binValue;
        }
        
        let input: ParseState = new ParseState(iso8601String);
        let value: number;
        let isNegativeYear: boolean = false;
        
        if (input.ch(0) === '-') {
            input.skip();
            isNegativeYear = true;
        }
        
        // 提取年份
        value = input.gatherInt("Invalid year in date string", 9999);
        if (input.hasNext() && input.ch() !== '-') {
            throw new XMPException("Invalid date string, after year", XMPError.BADVALUE);
        }
        
        if (isNegativeYear) {
            value = -value;
        }
        binValue.setYear(value);
        if (!input.hasNext()) {
            return binValue;
        }
        input.skip();
        
        // 提取月份
        value = input.gatherInt("Invalid month in date string", 12);
        if (input.hasNext() && input.ch() !== '-') {
            throw new XMPException("Invalid date string, after month", XMPError.BADVALUE);
        }
        binValue.setMonth(value);
        if (!input.hasNext()) {
            return binValue;
        }
        input.skip();
        
        // 提取日期
        value = input.gatherInt("Invalid day in date string", 31);
        if (input.hasNext() && input.ch() !== 'T') {
            throw new XMPException("Invalid date string, after day", XMPError.BADVALUE);
        }
        binValue.setDay(value);
        if (!input.hasNext()) {
            return binValue;
        }
        input.skip();
        
        // 提取小时
        value = input.gatherInt("Invalid hour in date string", 23);
        binValue.setHour(value);
        if (!input.hasNext()) {
            return binValue;
        }
        
        // 提取分钟
        if (input.ch() === ':') {
            input.skip();
            value = input.gatherInt("Invalid minute in date string", 59);
            if (input.hasNext() &&
                input.ch() !== ':' && input.ch() !== 'Z' && input.ch() !== '+' && input.ch() !== '-') {
                throw new XMPException("Invalid date string, after minute", XMPError.BADVALUE);
            }
            binValue.setMinute(value);
        }
        
        if (!input.hasNext()) {
            return binValue;
        } else if (input.hasNext() && input.ch() === ':') {
            input.skip();
            value = input.gatherInt("Invalid whole seconds in date string", 59);
            if (input.hasNext() && input.ch() !== '.' && input.ch() !== 'Z' && 
                input.ch() !== '+' && input.ch() !== '-') {
                throw new XMPException("Invalid date string, after whole seconds", XMPError.BADVALUE);
            }
            binValue.setSecond(value);
            if (input.ch() === '.') {
                input.skip();
                let digits: number = input.pos();
                value = input.gatherInt("Invalid fractional seconds in date string", 999999999);
                if (input.hasNext() &&
                    (input.ch() !== 'Z' && input.ch() !== '+' && input.ch() !== '-')) {
                    throw new XMPException("Invalid date string, after fractional second", XMPError.BADVALUE);
                }
                digits = input.pos() - digits;
                for (; digits > 9; --digits) {
                    value = value / 10;
                }
                for (; digits < 9; ++digits) {
                    value = value * 10;
                }
                binValue.setNanoSecond(value);
            }
        } else if (input.ch() !== 'Z' && input.ch() !== '+' && input.ch() !== '-') {
            throw new XMPException("Invalid date string, after time", XMPError.BADVALUE);
        }
        
        let tzSign: number = 0;
        let tzHour: number = 0;
        let tzMinute: number = 0;
        
        if (!input.hasNext()) {
            // 没有时区
            return binValue;
        } else if (input.ch() === 'Z') {
            input.skip();
        } else if (input.hasNext()) {
            if (input.ch() === '+') {
                tzSign = 1;
            } else if (input.ch() === '-') {
                tzSign = -1;
            } else {
                throw new XMPException("Time zone must begin with 'Z', '+', or '-', XMPError.BADVALUE", 0);
            }
            
            input.skip();
            // 提取时区小时
            tzHour = input.gatherInt("Invalid time zone hour in date string", 23);
            if (input.hasNext()) {
                if (input.ch() === ':') {
                    input.skip();
                    
                    // 提取时区分钟
                    tzMinute = input.gatherInt("Invalid time zone minute in date string", 59);
                } else {
                    throw new XMPException("Invalid date string, after time zone hour", XMPError.BADVALUE);
                }
            }
        }
        
        // 创建相应的时区并设置
        let offset: number = (tzHour * 3600 * 1000 + tzMinute * 60 * 1000) * tzSign;
        binValue.setTimeZoneOffset(offset);
        
        if (input.hasNext()) {
            throw new XMPException("Invalid date string, extra chars at end", XMPError.BADVALUE);
        }
        
        return binValue;
    }
    
    /**
     * 将XMPDateTime对象转换为ISO 8601字符串
     * 根据ISO 8601和http://www.w3.org/TR/NOTE-datetime格式化日期
     * 
     * @param dateTime XMPDateTime对象
     * @return 返回ISO 8601字符串
     */
    public static render(dateTime: XMPDateTime): string {
        let buffer: string = '';
        
        if (dateTime.hasDate()) {
            // 年份始终被渲染，即使是0000
            buffer += ISO8601Converter.formatNumber(dateTime.getYear(), 4);
            if (dateTime.getMonth() === 0) {
                return buffer;
            }
            
            // 月份
            buffer += '-' + ISO8601Converter.formatNumber(dateTime.getMonth(), 2);
            if (dateTime.getDay() === 0) {
                return buffer;
            }
            
            // 日期
            buffer += '-' + ISO8601Converter.formatNumber(dateTime.getDay(), 2);
            
            // 时间，如果任何时间字段不为零则渲染
            if (dateTime.hasTime()) {
                // 小时和分钟
                buffer += 'T';
                buffer += ISO8601Converter.formatNumber(dateTime.getHour(), 2);
                buffer += ':' + ISO8601Converter.formatNumber(dateTime.getMinute(), 2);
                
                // 秒和纳秒
                if (dateTime.getSecond() !== 0 || dateTime.getNanoSecond() !== 0) {
                    let seconds: number = dateTime.getSecond() + dateTime.getNanoSecond() / 1000000000;
                    buffer += ':' + ISO8601Converter.formatSeconds(seconds);
                }
                
                // 时区
                if (dateTime.hasTimeZone()) {
                    let offset: number = dateTime.getTimeZoneOffset();
                    if (offset === 0) {
                        // UTC
                        buffer += 'Z';
                    } else {
                        let thours: number = Math.floor(offset / 3600000);
                        let tminutes: number = Math.abs((offset % 3600000) / 60000);
                        buffer += (thours >= 0 ? '+' : '') + ISO8601Converter.formatNumber(thours, 2);
                        buffer += ':' + ISO8601Converter.formatNumber(tminutes, 2);
                    }
                }
            }
        }
        
        return buffer;
    }
    
    /**
     * 格式化数字为指定长度的字符串，前导零填充
     * @param num 数字
     * @param length 长度
     * @return 格式化后的字符串
     */
    private static formatNumber(num: number, length: number): string {
        let sign: string = '';
        let absNum: number = Math.abs(num);
        if (num < 0) {
            sign = '-';
        }
        let str: string = absNum.toString();
        while (str.length < length) {
            str = '0' + str;
        }
        return sign + str;
    }
    
    /**
     * 格式化秒数，包括小数部分
     * @param seconds 秒数
     * @return 格式化后的秒数字符串
     */
    private static formatSeconds(seconds: number): string {
        let wholeSeconds: number = Math.floor(seconds);
        let fractional: number = seconds - wholeSeconds;
        let result: string = ISO8601Converter.formatNumber(wholeSeconds, 2);
        
        if (fractional > 0) {
            let fractionalStr: string = fractional.toFixed(9).substring(2).replace(/0+$/, '');
            if (fractionalStr.length > 0) {
                result += '.' + fractionalStr;
            }
        }
        
        return result;
    }
}

/**
 * 解析状态辅助类
 */
class ParseState {
    /** 输入字符串 */
    private str: string;
    /** 当前位置 */
    private cPos: number = 0;
    
    /**
     * @param str 初始化解析器容器
     */
    constructor(str: string) {
        this.str = str;
    }
    
    /**
     * @return 返回输入的长度
     */
    public length(): number {
        return this.str.length;
    }
    
    /**
     * @return 返回是否还有更多字符
     */
    public hasNext(): boolean {
        return this.cPos < this.str.length;
    }
    
    /**
     * @param index 字符索引
     * @return 返回特定索引处的字符
     */
    public ch(index?: number): string {
        if(index === undefined){
            return this.cPos < this.str.length ?
                this.str.charAt(this.cPos):
                '\0';
        }
        return index < this.str.length ? this.str.charAt(index) : '\0';
    }
    
    /**
     * @return 返回当前字符，如果没有更多字符则返回\0
     */
    public currentChar(): string {
        return this.cPos < this.str.length ? this.str.charAt(this.cPos) : '\0';
    }
    
    /**
     * 跳过下一个字符
     */
    public skip(): void {
        this.cPos++;
    }
    
    /**
     * @return 返回当前位置
     */
    public pos(): number {
        return this.cPos;
    }
    
    /**
     * 从源解析整数并将指针设置在其后
     * @param errorMsg 如果找不到数字，放入异常中的错误消息
     * @param maxValue 返回数字的最大值
     * @return 返回解析的整数
     * @throws XMPException 如果找不到整数则抛出
     */
    public gatherInt(errorMsg: string, maxValue: number): number {
        let value: number = 0;
        let success: boolean = false;
        let ch: string = this.ch(this.cPos);
        while (ch >= '0' && ch <= '9') {
            value = (value * 10) + (parseInt(ch) - 0);
            success = true;
            this.cPos++;
            ch = this.ch(this.cPos);
        }
        
        if (success) {
            if (value > maxValue) {
                return maxValue;
            } else if (value < 0) {
                return 0;
            } else {
                return value;
            }
        } else {
            throw new XMPException(errorMsg, XMPError.BADVALUE);
        }
    }
}