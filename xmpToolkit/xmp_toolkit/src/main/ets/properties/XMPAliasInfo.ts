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

import AliasOptions from "../options/AliasOptions";

/**
 * This interface is used to return information about an alias. An alias is a
 * pair of namespace and property name.
 * 
 * @since 2.2
 */
export default interface XMPAliasInfo {
    
    /**
     * @return Returns the namespace of the base property.
     */
    getNamespace(): string;
    
    /**
     * @return Returns the default prefix of the base property.
     */
    getPrefix(): string;
    
    /**
     * @return Returns the path of the base property.
     */
    getPropName(): string;
    
    /**
     * @return Returns the kind of the alias. This can be a direct alias
     *         (ARRAY), a simple alternative array item (ARRAY_ITEM) or a 
     *         complex alternative array item (STRUCT_ARRAY_ITEM).
     */
    getAliasForm(): AliasOptions;

    toString(): string;
}
