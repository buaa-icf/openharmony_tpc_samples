/*
 * Copyright (C) 2021 Huawei Device Co., Ltd.
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

let context = globalThis.mainAbilityContext;

export namespace AbilityHandle {

    async function jumpToAbility(targetsAbility: string) {
        try {
            await context.startAbility({
                bundleName: "com.example.asn1demo",
                abilityName: targetsAbility
            })
            console.log("aasaff",'start targetsAbility ability success');
        } catch (error) {
            console.error("aasaff",'start targetsAbility ability failed with ${error.code}' )
        }
    }

    export let jump = function (targetAbility) {
        return jumpToAbility(targetAbility);
    }

    export async function finishAbility(){
        try{
            await context.terminateSelf();
        }catch(error){
            console.error("aasaff",'start targetsAbility ability failed with ${error.code}' )
        }
    }
}