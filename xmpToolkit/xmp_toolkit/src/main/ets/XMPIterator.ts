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

import XMPPropertyInfo  from './properties/XMPPropertyInfo';

/**
 * Interface for the <code>XMPMeta</code> iteration services.
 * <code>XMPIterator</code> provides a uniform means to iterate over the
 * schema and properties within an XMP object.
 */
export default interface XMPIterator {
    /**
     * Skip the subtree below the current node when <code>next()</code> is
     * called.
     */
    skipSubtree(): void;

    /**
     * Skip the subtree below and remaining siblings of the current node when
     * <code>next()</code> is called.
     */
    skipSiblings(): void;

    /**
     * Returns true if the iteration has more elements.
     * @return true if the iteration has more elements
     */
    hasNext(): boolean;

    /**
     * Returns the next element in the iteration.
     * @return the next element in the iteration
     */
    next(): XMPPropertyInfo;

    /**
     * Removes from the underlying collection the last element returned by this iterator.
     */
    remove(): void;
}