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

import XMPException from './XMPException';
import XMPAliasInfo from './properties/XMPAliasInfo';

/**
 * The schema registry keeps track of all namespaces and aliases used in the XMP
 * metadata. At initialisation time, the default namespaces and default aliases
 * are automatically registered.
 */
interface XMPSchemaRegistry {
  // ----------------------------------------------------------  // Namespace Functions

  /**
   * Register a namespace URI with a suggested prefix.
   * 
   * @param namespaceURI The URI for the namespace. Must be a valid XML URI.
   * @param suggestedPrefix The suggested prefix to be used if the URI is not yet registered.
   * @return Returns the registered prefix for this URI.
   * @throws XMPException If the parameters are not accordingly set
   */
  registerNamespace(namespaceURI: string, suggestedPrefix: string): string;

  /**
   * Obtain the prefix for a registered namespace URI.
   * 
   * @param namespaceURI The URI for the namespace. Must not be null or the empty string.
   * @return Returns the prefix registered for this namespace URI or null.
   */
  getNamespacePrefix(namespaceURI: string): string | null;

  /**
   * Obtain the URI for a registered namespace prefix.
   * 
   * @param namespacePrefix The prefix for the namespace. Must not be null or the empty string.
   * @return Returns the URI registered for this prefix or null.
   */
  getNamespaceURI(namespacePrefix: string): string | null;

  /**
   * @return Returns the registered prefix/namespace-pairs as map, where the keys are the
   *         namespaces and the values are the prefixes.
   */
  getNamespaces(): Map<string, string>;

  /**
   * @return Returns the registered namespace/prefix-pairs as map, where the keys are the
   *         prefixes and the values are the namespaces.
   */
  getPrefixes(): Map<string, string>;

  /**
   * Deletes a namespace from the registry.
   * 
   * @param namespaceURI The URI for the namespace.
   */
  deleteNamespace(namespaceURI: string): void;

  // ---------------------------------------------------------------------------------------------  // Alias Functions

  /**
   * Determines if a name is an alias, and what it is aliased to.
   * 
   * @param aliasNS The namespace URI of the alias. Must not be null or the empty string.
   * @param aliasProp The name of the alias. May be an arbitrary path expression path.
   * @return Returns the XMPAliasInfo for the given alias namespace and property or
   *         null if there is no such alias.
   */
  resolveAlias(aliasNS: string, aliasProp: string): XMPAliasInfo | null;

  /**
   * Collects all aliases that are contained in the provided namespace.
   * 
   * @param aliasNS a schema namespace URI
   * @return Returns all alias infos from aliases that are contained in the provided namespace.
   */
  findAliases(aliasNS: string): XMPAliasInfo[];

  /**
   * Searches for registered aliases.
   * 
   * @param qname an XML conform qname
   * @return Returns if an alias definition for the given qname to another
   *         schema and property is registered.
   */
  findAlias(qname: string): XMPAliasInfo | null;

  /**
   * @return Returns the registered aliases as map, where the key is the "qname" (prefix and name)
   * and the value an XMPAliasInfo-object.
   */
  getAliases(): Map<string, XMPAliasInfo>;
}

export default XMPSchemaRegistry;