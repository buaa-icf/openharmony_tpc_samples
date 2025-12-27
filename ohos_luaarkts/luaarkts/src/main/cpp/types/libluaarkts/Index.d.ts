/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
export const TestHelloWorld: (a: string) => string;
export const InitLuaEnv: (path: string) => void;
export const SetLogShowState: (bLogShowState: Boolean) => void;
export const GetLuaStateL: () => ESObject;


export const T2lSetVarInt: (luaFunc: string, value: number) => void;
export const T2lSetVarLong: (luaFunc: string, value: number) => void;
export const T2lSetVarDouble: (luaFunc: string, value: number) => void;
export const T2lSetVarChar: (luaFunc: string, value: string) => void;
export const T2lSetVarBool: (luaFunc: string, value: boolean) => void;
export const T2lGetVarInt: (luaFunc: string) => number;
export const T2lGetVarLong: (luaFunc: string) => number;
export const T2lGetVarDouble: (luaFunc: string) => number;
export const T2lGetVarChar: (luaFunc: string) => number;
export const T2lGetVarBool: (luaFunc: string) => number;
export const T2lGetTableInt: (luaTable: string, tableVarName:string) => number;
export const T2lGetTableLong: (luaTable: string, tableVarName:string) => number;
export const T2lGetTableDouble: (luaTable: string, tableVarName:string) => number;
export const T2lGetTableChar: (luaTable: string, tableVarName:string) => number;
export const T2lGetTableBool: (luaTable: string, tableVarName:string) => number;

export const T2lCallFunction: (luaFunc: string, ...numbers: ESObject[]) => ESObject;
export const TestNAPI: (a: number, b: number) => number;

export const T2lSetTableInt:(tab:string, field:string, val:number) => void;
export const T2lSetTableLong:(tab:string, field:string, val:number) => void;
export const T2lSetTableDouble:(tab:string, field:string, val:number) => void;
export const T2lSetTableString:(tab:string, field:string, val:string) => void;
export const T2lSetTableBool:(tab:string, field:string, val:Boolean) => void;

//export const TestNAPI: () => void;