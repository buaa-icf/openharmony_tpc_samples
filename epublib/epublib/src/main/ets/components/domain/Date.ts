/*
 * Copyright (C) 2022 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

class Date {
    private event: string;
    private dateString: string;

    public constructor(dateString: string, event: string) {
        this.dateString = dateString;
        this.event = event;
    }

    private static checkDate(dateString: string): string{
        if (dateString == null) {
            throw new Error("Cannot create a date from a blank string");
        }
        return dateString;
    }

    public getValue(): string{
        return this.dateString;
    }

    public getEvent(): string{
        return this.event;
    }

    public setEvent(event: string): void{
        this.event = event;
    }

    public toString(): string{
        if (this.event == null) {
            return this.dateString;
        }
        return "" + this.event + ":" + this.dateString;
    }
}

export default Date