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
 * This interface is used to return property information when these are iterated.
 */
export default interface XMPPropertyInfo {
    
    /**
     * @return Returns the namespace of the property.
     */
    getNamespace(): string;
    
    /**
     * @return Returns the path of the property.
     */
    getPath(): string;
    
    /**
     * @return Returns the value of the property.
     */
    getValue(): string;
    
    /**
     * @return Returns the options of the property.
     */
    getOptions(): number;
}
