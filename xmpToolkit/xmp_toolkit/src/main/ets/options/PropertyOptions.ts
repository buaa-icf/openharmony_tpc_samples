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

import Options from './Options';
import XMPException from '../XMPException';
import XMPError from '../XMPError';

/**
 * PropertyOptions defines the property types and qualifiers for XMP properties.
 */
export default class PropertyOptions extends Options {
  /** No options are set. */
  public static readonly NO_OPTIONS = 0x00000000;
  
  /** The property value is a URI. */
  public static readonly URI = 0x00000002;
  
  /** The property has qualifiers. */
  public static readonly HAS_QUALIFIERS = 0x00000010;
  
  /** The property itself is a qualifier. */
  public static readonly QUALIFIER = 0x00000020;
  
  /** The property has a language qualifier. */
  public static readonly HAS_LANGUAGE = 0x00000040;
  
  /** The property has a type qualifier. */
  public static readonly HAS_TYPE = 0x00000080;
  
  /** The property is a struct. */
  public static readonly STRUCT = 0x00000100;
  
  /** The property is an array. */
  public static readonly ARRAY = 0x00000200;
  
  /** The property is an ordered array. */
  public static readonly ARRAY_ORDERED = 0x00000400;
  
  /** The property is an alternate array. */
  public static readonly ARRAY_ALTERNATE = 0x00000800;
  
  /** The property is an alt-text array. */
  public static readonly ARRAY_ALT_TEXT = 0x00001000;
  
  /** The property is a schema node. */
  public static readonly SCHEMA_NODE = 0x80000000;

  /**
   * The default constructor.
   */
  public constructor();
  /**
   * Constructor with initial options.
   * 
   * @param options the initial options
   * @throws XMPException if the options are invalid
   */
  public constructor(options: number);
  /**
   * Implementation of overloaded constructor
   */
  public constructor(options?: number) {
    super();
    if (options !== undefined) {
      this.setOptions(options);
    }
  }

  /**
   * @return Return whether this property is a URI.
   */
  public isURI(): boolean {
    return this.getOption(PropertyOptions.URI);
  }

  /**
   * @param value the value to set
   * @return Returns this to enable cascaded options.
   */
  public setURI(value: boolean): PropertyOptions {
    this.setOption(PropertyOptions.URI, value);
    return this;
  }

  /**
   * @return Return whether this property has qualifiers.
   */
  public getHasQualifiers(): boolean {
    return this.getOption(PropertyOptions.HAS_QUALIFIERS);
  }

  /**
   * @param value the value to set
   * @return Returns this to enable cascaded options.
   */
  public setHasQualifiers(value: boolean): PropertyOptions {
    this.setOption(PropertyOptions.HAS_QUALIFIERS, value);
    return this;
  }

  /**
   * @return Return whether this property is a qualifier.
   */
  public isQualifier(): boolean {
    return this.getOption(PropertyOptions.QUALIFIER);
  }

  /**
   * @param value the value to set
   * @return Returns this to enable cascaded options.
   */
  public setQualifier(value: boolean): PropertyOptions {
    this.setOption(PropertyOptions.QUALIFIER, value);
    return this;
  }

  /**
   * @return Return whether this property has a language qualifier.
   */
  public getHasLanguage(): boolean {
    return this.getOption(PropertyOptions.HAS_LANGUAGE);
  }

  /**
   * @param value the value to set
   * @return Returns this to enable cascaded options.
   */
  public setHasLanguage(value: boolean): PropertyOptions {
    this.setOption(PropertyOptions.HAS_LANGUAGE, value);
    return this;
  }

  /**
   * @return Return whether this property has a type qualifier.
   */
  public getHasType(): boolean {
    return this.getOption(PropertyOptions.HAS_TYPE);
  }

  /**
   * @param value the value to set
   * @return Returns this to enable cascaded options.
   */
  public setHasType(value: boolean): PropertyOptions {
    this.setOption(PropertyOptions.HAS_TYPE, value);
    return this;
  }

  /**
   * @return Return whether this property is a struct.
   */
  public isStruct(): boolean {
    return this.getOption(PropertyOptions.STRUCT);
  }

  /**
   * @param value the value to set
   * @return Returns this to enable cascaded options.
   */
  public setStruct(value: boolean): PropertyOptions {
    this.setOption(PropertyOptions.STRUCT, value);
    return this;
  }

  /**
   * @return Return whether this property is an array.
   */
  public isArray(): boolean {
    return this.getOption(PropertyOptions.ARRAY);
  }

  /**
   * @param value the value to set
   * @return Returns this to enable cascaded options.
   */
  public setArray(value: boolean): PropertyOptions {
    this.setOption(PropertyOptions.ARRAY, value);
    return this;
  }

  /**
   * @return Return whether this property is an ordered array.
   */
  public isArrayOrdered(): boolean {
    return this.getOption(PropertyOptions.ARRAY_ORDERED);
  }

  /**
   * @param value the value to set
   * @return Returns this to enable cascaded options.
   */
  public setArrayOrdered(value: boolean): PropertyOptions {
    this.setOption(PropertyOptions.ARRAY_ORDERED, value);
    return this;
  }

  /**
   * @return Return whether this property is an alternative array.
   */
  public isArrayAlternate(): boolean {
    return this.getOption(PropertyOptions.ARRAY_ALTERNATE);
  }

  /**
   * @param value the value to set
   * @return Returns this to enable cascaded options.
   */
  public setArrayAlternate(value: boolean): PropertyOptions {
    this.setOption(PropertyOptions.ARRAY_ALTERNATE, value);
    return this;
  }

  /**
   * @return Return whether this property is an alt-text array.
   */
  public isArrayAltText(): boolean {
    return this.getOption(PropertyOptions.ARRAY_ALT_TEXT);
  }

  /**
   * @param value the value to set
   * @return Returns this to enable cascaded options.
   */
  public setArrayAltText(value: boolean): PropertyOptions {
    this.setOption(PropertyOptions.ARRAY_ALT_TEXT, value);
    return this;
  }

  /**
   * @return Returns whether the SCHEMA_NODE option is set.
   */
  public isSchemaNode(): boolean {
    return this.getOption(PropertyOptions.SCHEMA_NODE);
  }

  /**
   * @param value the option SCHEMA_NODE to set
   * @return Returns this to enable cascaded options.
   */
  public setSchemaNode(value: boolean): PropertyOptions {
    this.setOption(PropertyOptions.SCHEMA_NODE, value);
    return this;
  }

  //-------------------------------------------------------------------------- convenience methods

  /**
   * @return Returns whether the property is of composite type - an array or a struct.
   */
  public isCompositeProperty(): boolean {
    return (this.getOptions() & (PropertyOptions.ARRAY | PropertyOptions.STRUCT)) > 0;
  }

  /**
   * @return Returns whether the property is of simple type - not an array or a struct.
   */
  public isSimple(): boolean {
    return (this.getOptions() & (PropertyOptions.ARRAY | PropertyOptions.STRUCT)) === 0;
  }

  /**
   * Compares two options set for array compatibility.
   * 
   * @param options other options
   * @return Returns true if the array options of the sets are equal.
   */
  public equalArrayTypes(options: PropertyOptions): boolean {
    return this.isArray() === options.isArray() &&
           this.isArrayOrdered() === options.isArrayOrdered() &&
           this.isArrayAlternate() === options.isArrayAlternate() &&
           this.isArrayAltText() === options.isArrayAltText();
  }

  /**
   * Merges the set options of another options object with this.
   * If the other options set is null, this object stays the same.
   * @param options other options
   * @throws XMPException If illegal options are provided 
   */
  public mergeWith(options: PropertyOptions | null): void {
    if (options !== null) {
      this.setOptions(this.getOptions() | options.getOptions());
    }
  }

  /**
   * @return Returns true if only array options are set.
   */
  public isOnlyArrayOptions(): boolean {
    return (this.getOptions() & 
           ~(PropertyOptions.ARRAY | 
             PropertyOptions.ARRAY_ORDERED | 
             PropertyOptions.ARRAY_ALTERNATE | 
             PropertyOptions.ARRAY_ALT_TEXT)) === 0;
  }

  /**
   * @see Options#getValidOptions()
   */
  protected getValidOptions(): number {
    return PropertyOptions.URI |
           PropertyOptions.HAS_QUALIFIERS |
           PropertyOptions.QUALIFIER |
           PropertyOptions.HAS_LANGUAGE |
           PropertyOptions.HAS_TYPE |
           PropertyOptions.STRUCT |
           PropertyOptions.ARRAY |
           PropertyOptions.ARRAY_ORDERED |
           PropertyOptions.ARRAY_ALTERNATE |
           PropertyOptions.ARRAY_ALT_TEXT |
           PropertyOptions.SCHEMA_NODE;
  }

  /**
   * @see Options#defineOptionName(int)
   */
  protected defineOptionName(option: number): string | null {
    switch (option) {
      case PropertyOptions.URI:              return "URI";
      case PropertyOptions.HAS_QUALIFIERS:   return "HAS_QUALIFIER";
      case PropertyOptions.QUALIFIER:        return "QUALIFIER";
      case PropertyOptions.HAS_LANGUAGE:     return "HAS_LANGUAGE";
      case PropertyOptions.HAS_TYPE:         return "HAS_TYPE";
      case PropertyOptions.STRUCT:           return "STRUCT";
      case PropertyOptions.ARRAY:            return "ARRAY";
      case PropertyOptions.ARRAY_ORDERED:    return "ARRAY_ORDERED";
      case PropertyOptions.ARRAY_ALTERNATE:  return "ARRAY_ALTERNATE";
      case PropertyOptions.ARRAY_ALT_TEXT:   return "ARRAY_ALT_TEXT";
      case PropertyOptions.SCHEMA_NODE:      return "SCHEMA_NODE";
      default:                               return null;
    }
  }

  /**
   * Checks that a node is not a struct and array at the same time;
   * and URI cannot be a struct.
   * 
   * @param options the bitmask to check.
   * @throws XMPException Thrown if the options are not consistent.
   */
  public assertConsistency(options: number): void {
    if ((options & PropertyOptions.STRUCT) > 0 && (options & PropertyOptions.ARRAY) > 0) {
      throw new XMPException(
        "IsStruct and IsArray options are mutually exclusive",
        XMPError.BADOPTIONS
      );
    } else if ((options & PropertyOptions.URI) > 0 && (options & (PropertyOptions.ARRAY | PropertyOptions.STRUCT)) > 0) {
      throw new XMPException(
        "Structs and arrays can't have \"value\" options",
        XMPError.BADOPTIONS
      );
    }
  }
}

