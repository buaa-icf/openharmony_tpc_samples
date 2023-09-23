import buffer from '@ohos.buffer';


interface addressSchema1 {
  type: string
}

interface addressSchema2 {
  id: string;
  type: string;
  properties: {
    lines: {
      type: string;
      items: { type: string; };
    };
    zip: { type: string; };
    city: { type: string; };
    country: { type: string; };
  };
  required: string[];
}

interface schema {
  id: string;
  type: string;
  properties: {
    name: { type: string; };
    address: { $ref: string; };
    votes: {
      type: string;
      minimum: number;
    };
  };
}

interface p {
  name: string;
  address: {
    lines: string[];
    zip: string;
    city: string;
    country: string;
  };
  votes: string;
}

interface schenatada {
  id: string;
  type: string;
  properties: {
    validateType1: { type: string; };
    validateType3: { not: string; };
    validateTType2: { type: string[]; };
    validateype4: { disallow: string[]; };
    validateProperties: {
      type: string;
      properties: {
        a: { type: string; },
        b: { type: string; }
      }
    }
    validatePatternProperties: {
      type: string;
      patternProperties: {
        "^x1\\d*$": { type: string; };
        "^[a-z]+$": { type: string; };
      };
    }
    validateAdditionalProperties1: {
      type: string;
      properties: { a: { type: string; }; };
      patternProperties: { "[b-z]+": { type: string; }; };
      additionalProperties: { type: string; };
    }
    validateAdditionalProperties2: {
      type: string;
      properties: { a: { type: string; }; };
      patternProperties: { "[b-z]+": { type: string; }; };
      additionalProperties: boolean;
    }
    validateNumberOfProperties: {
      type: string;
      patternProperties: { "[a-z]+": { type: string; }; };
      minProperties: number;
      maxProperties: number;
    }
    validateRequired: {
      type: string;
      required: boolean;
    }
    validateRequiredProperties1: {
      type: string;
      required: string[];
    }
    validateRequiredProperties2: {
      type: string;
      properties: {
        propA: { required: boolean; };
        propB: { required: boolean; };
      };
    }
    validateItems: {
      type: string;
      items: { type: string; };
    }
    validateNumberOfItems: {
      type: string;
      minItems: number;
      maxItems: number;
    }
    validateUniqueItems: {
      type: string;
      uniqueItems: boolean;
    }
    validateNumber: {
      type: string[];
      minimum: number;
      maximum: number;
      divisibleBy: number;
      multipleOf: number;
    }
    validateInteger: {
      type: string[];
      divisibleBy: number;
      multipleOf: number;
    }
    validatePattern1: {
      type: string;
      pattern: string;
    }
    validatePattern2: {
      type: string;
      pattern: string;
    }
    validateFormat: {
      type: string;
      format: string;
    }
    validateLength: {
      type: string;
      minLength: number;
      maxLength: number;
    }
    validateEnum: { enum: (string | { x: number; })[]; }
    validateDependencies1: {
      type: string;
      properties: {
        a: { type: string; };
        b: { type: string; };
      };
      dependencies: { a: string; };
    }
    validateDependencies2: {
      type: string;
      properties: {
        a: { type: string; };
        b: { type: string; };
        c: { type: string; };
      };
      dependencies: { a: string[]; };
    }
    validateAnyOf: { anyOf: { type: string; }[]; }
    validateAllOf: { allOf: ({ type: string; } | { enum: boolean[]; })[]; }
    validateOneOf: { oneOf: { type: string; }[]; }
    validateReference: { $ref: string; }

  }
}
interface resulttada{
  type: string;
  format: string
}
interface referenceddata{
  id: string;
  type: string;
}
interface alldata{
  validateType1: string;
  validateType2: boolean;
  validateType3: number;
  validateType4: number;
  validateProperties: {
    a: undefined[][];
    b: number;
  };
  validatePatternProperties: {
    x11: undefined[][];
    abc: number;
  };
  validateAdditionalProperties1:{
    a: undefined[];
    bcd: number;
    11: boolean;
  }
  validateAdditionalProperties2: {
    a: undefined[];
    bcd: number;
  }
  validateNumberOfProperties: {
    abc: string;
  }
  validateRequired: number
  validateRequiredProperties1: {
    propA: number;
    propB: string;
  }
  validateRequiredProperties2: {
    propA: number;
    propB: string;
  }
  validateItems:string[]
  validateNumberOfItems:string[]
  validateUniqueItems:string[]
  validateNumber: number,
  validateInteger: number,
  validatePattern1:  string,
  validatePattern2: string,
  validateFormat: string,
  validateLength: string,
  validateEnum: {
    x: number;
  }
  validateDependencies1:{
    a: string;
    b: boolean;
  }
  validateDependencies2: {
    a: string;
    b: boolean;
    c: number;
  }
  validateAnyOf: string,
  validateAllOf: boolean,
  validateOneOf: number,
  validateReference: string

}


let typeFn = (type: string): addressSchema1 => {
  const typeData: addressSchema1 = {
    type: type,
  }
  return typeData
}

let typeresult =(type:string,format: string):resulttada =>{
  const typedata9:resulttada ={
    type:type,
    format:format
  }
  return typedata9
}

let typelines = (id: string, type1: string, type2: string, type3: string, type4: string, type5: string, type6: string, required: string[]): addressSchema2 => {
  const typeData2: addressSchema2 = {
    id: id,
    type: type1,
    properties: {
      lines: {
        type: type2,
        items: {
          type: type3
        }
      },
      zip: {
        type: type4
      },
      city: {
        type: type5
      },
      country: {
        type: type6
      }
    },
    required: required
  }
  return typeData2
}
let typeschema = (id: string, type: string, type1: string, $ref: string, type2: string, minimum: number): schema => {
  const typeData3: schema = {
    id: id,
    type: type,
    properties: {
      name: {
        type: type1
      },
      address: {
        $ref: $ref
      },
      votes: {
        type: type2,
        minimum: minimum
      }
    }
  }
  return typeData3
}
let typep = (name: string, lines: string[], zip: string, city: string, country: string, votes: string): p => {
  const typedata4: p = {
    name: name,
    address: {
      lines: lines,
      zip: zip,
      city: city,
      country: country
    },
    votes: votes
  }
  return typedata4
}
let referenced  =(id:string,type:string):referenceddata=>{
  const  typedata5:referenceddata= {
    id:id,
    type: type
  }
  return typedata5
}

let alltext =(validateType1:string,validateType2:boolean,validateType3:number,validateType4:number,a: undefined[],b:number,x11: undefined[],abc:number,a1: undefined[],bcd:number,ll:boolean,a2: undefined[],bcd1:number,abc1:string,validateRequired:number,propA:number,propB:string,propAA:number,propBB:string,validateItems:string[],validateNumberOfItems:string[], validateUniqueItems:string[],validateNumber:number,validateInteger:number,validatePattern1:string,validatePattern2:string,validateFormat:string,validateLength:string,x:number,a3:string,b1:boolean,a4:string,b2:boolean,c:number,validateAnyOf:string,validateAllOf:boolean,validateOneOf:number,validateReference:string):alldata =>{
  const  typedata6:alldata= {
    validateType1: validateType1,
    validateType2: validateType2,
    validateType3: validateType3,
    validateType4: validateType4,
    validateProperties: {
      a:a,
      b: b
    },
    validatePatternProperties: {
      x11: x11,
      abc:abc
    },
    validateAdditionalProperties1: {
      a: a1,
      bcd: bcd,
      11: ll
    },
    validateAdditionalProperties2: {
      a: a2,
      bcd:bcd1
    },
    validateNumberOfProperties: {
      abc: abc1
    },
    validateRequired: validateRequired,
    validateRequiredProperties1: {
      propA: propA,
      propB:propB
    },
    validateRequiredProperties2: {
      propA: propAA,
      propB: propBB
    },
    validateItems:validateItems,
    validateNumberOfItems: validateNumberOfItems,
    validateUniqueItems: validateUniqueItems,
    validateNumber: validateNumber,
    validateInteger: validateInteger,
    validatePattern1: validatePattern1,
    validatePattern2: validatePattern2,
    validateFormat: validateFormat,
    validateLength: validateLength,
    validateEnum: {
      x: x
    },
    validateDependencies1: {
      a: a3,
      b: b1
    },
    validateDependencies2: {
      a: a4,
      b: b2,
      c: c
    },
    validateAnyOf: validateAnyOf,
    validateAllOf: validateAllOf,
    validateOneOf: validateOneOf,
    validateReference: validateReference
  }

  return typedata6
}
interface nestedErrordata {
  nestedErrors:boolean
}

let nestedErrorstext =( nestedErrors:boolean):nestedErrordata=>{
  const typeerroe : nestedErrordata={
    nestedErrors:nestedErrors
  }
  return typeerroe
}

interface requireddata {
  required:boolean
}

let requiredtext =( required:boolean):requireddata=>{
  const typeerroe1: requireddata={
    required:required
  }
  return typeerroe1
}

interface containsda {
  type: string,
  contains: string
}

let containste =( type: string, contains: string):containsda=>{
  const typeerroe2: containsda={
    type: "string", contains: "I am"
  }
  return typeerroe2
}

interface  basedata{
  base:string
}
let basetsat=(base:string):basedata=>{
  const  typeerroe3:basedata={
    base: 'http://example.com/'
  }
  return typeerroe3
}
export {
  typeFn, typelines, typeschema, typep,referenced,alltext,typeresult, nestedErrorstext,requiredtext,containste,basetsat
}

export let schema = {
  dependencies: {
    bar: {
      properties: {
        foo: {
          type: "array",
          items: {
            type: "integer"
          },
        },
        bar: {
          type: "integer"
        },
      },
      required: ["foo", "bar"],
    },
  },
};

export let data = {
  foo: [1, 2, 3],
  bar: 2,
};

export function freeze(){
  Object.freeze(data.foo);
  Object.freeze(data);
}

export let schemadata = {
  id: "/All",
  type: "object",
  properties: {
    validateType1: {
      type: "string"
    },
    validateType2: {
      type: ["boolean", "string"]
    },
    validateType3: {
      not: "string",
    },
    validateType4: {
      disallow: ["boolean", "string"]
    },
    validateProperties: {
      type: "object",
      properties: {
        a: {
          type: "array"
        },
        b: {
          type: "integer"
        }
      }
    },
    validatePatternProperties: {
      type: "object",
      patternProperties: {
        "^x1\\d*$": {
          type: "array"
        },
        "^[a-z]+$": {
          type: "integer"
        }
      }
    },
    validateAdditionalProperties1: {
      type: "object",
      properties: {
        a: {
          type: "array"
        }
      },
      patternProperties: {
        "[b-z]+": {
          type: "integer"
        }
      },
      additionalProperties: {
        type: "boolean"
      }
    },
    validateAdditionalProperties2: {
      type: "object",
      properties: {
        a: {
          type: "array"
        }
      },
      patternProperties: {
        "[b-z]+": {
          type: "integer"
        }
      },
      additionalProperties: false
    },
    validateNumberOfProperties: {
      type: "object",
      patternProperties: {
        "[a-z]+": {
          type: "string"
        }
      },
      minProperties: 1,
      maxProperties: 2
    },
    validateRequired: {
      type: "any",
      required: true
    },
    validateRequiredProperties1: {
      type: "object",
      required: [
        "propA",
        "propB"
      ]
    },
    validateRequiredProperties2: {
      type: "object",
      properties: {
        propA: {
          required: true
        },
        propB: {
          required: true
        }
      }
    },
    validateItems: {
      type: "array",
      items: {
        type: "string"
      }
    },
    validateNumberOfItems: {
      type: "array",
      minItems: 1,
      maxItems: 2
    },
    validateUniqueItems: {
      type: "array",
      uniqueItems: true
    },
    validateNumber: {
      type: ["number"],
      minimum: 0,
      maximum: 10,
      divisibleBy: 2.4,
      multipleOf: 4.8
    },
    validateInteger: {
      type: ["integer"],
      divisibleBy: 2,
      multipleOf: 4
    },
    validatePattern1: {
      type: "string",
      pattern: "str"
    },
    validatePattern2: {
      type: "string",
      pattern: "/str/"
    },
    validateFormat: {
      type: "string",
      format: "color"
    },
    validateLength: {
      type: "string",
      minLength: 1,
      maxLength: 2
    },
    validateEnum: {
      enum: ["value", {x: 11}]
    },
    validateDependencies1: {
      type: "object",
      properties: {
        a: {
          type: "string",
        },
        b: {
          type: "boolean"
        }
      },
      dependencies: {
        a: "b"
      }
    },
    validateDependencies2: {
      type: "object",
      properties: {
        a: {
          type: "string",
        },
        b: {
          type: "boolean"
        },
        c: {
          type: "number"
        }
      },
      dependencies: {
        a: ["b", "c"]
      }
    },
    validateAnyOf: {
      anyOf: [
        {
          type: "boolean"
        },
        {
          type: "string"
        }
      ]
    },
    validateAllOf: {
      allOf: [
        {
          type: "boolean"
        },
        {
          enum: [true]
        }
      ]
    },
    validateOneOf: {
      oneOf: [
        {
          type: "boolean"
        },
        {
          type: "integer"
        }
      ]
    },

    validateReference: {
      $ref: "/ReferencedSchema"
    }
  }
};



export let schematext = {
  items: {
    $ref: '#/definitions/items'
  },
  definitions: {
    items: {
      type: 'array',
    },
  },
};

export let schemafuanction = {
  $id: 'http://example.com/foo.json',
  items: {
    $ref: '#'
  },
  type: 'array',
};
export let schemadoct = {
  $id: 'http://example.com/foo.json',
  items: {
    $ref: 'foo.json'
  },
  type: 'array',
};
export let schemastart = {
  properties: {
    a: {
      type: 'number'
    },
    b: {
      type: 'number'
    },
  },
};

export let schemaArr: object[] = [
  {
    type: "number"
  },
  {
    id: "/simplePerson",
    type: "object",
    properties: {
      name: {
        type: "string"
      },
      address: {
        $ref: "/SimpleAddress"
      },
      votes: {
        type: "integer", minimum: 1
      }
    }
  },
  {
    type: "array",
    items: {
      properties: {
        name: {
          type: "string"
        },
        lastname: {
          type: "string"
        }
      },
      required: ["name", "lastname"]
    }
  },
]
export const initSchema = {
  type: 'object',
  anyOf: [{
    properties: {
      name: { type: 'string', enum: ['test1'] },
    },
  }, {
    properties: {
      name: { type: 'string', enum: ['test2'] },
    },
  }],
};

export const oneOfSchema = {
  type: 'object',
  oneOf: [{
    properties: {
      name1: { type: 'string', enum: ['test1'] },
    },
    additionalProperties: false,
  }, {
    properties: {
      name2: { type: 'string', enum: ['test2'] },
    },
    additionalProperties: false,
  }],
};

export let schemajsons = {
  oneOf: [
    {
      type: 'string', minLength: 32, maxLength: 32
    },
    {
      type: 'string', maxLength: 16
    },
  typeFn('number'),
  ]
};

export let pjson = {
  name: "张三",
  sex: 45,
  votes: 22
};

export let schemastartTime1 = {
  type: "string",
  format: "email",
  example: "foo",
};

export const schemajsonpro = {
  properties: {
    name: {
      type: 'string'
    },
    quantity: {
      type: 'number'
    }
  }
};
export const instancejson = {
  name: 123,
  quantity: '2'
}

export const schemavalue = {
  properties: {
    date: {
      id: 'http://example.com/date', type: 'string'
    },
  },
};

export const value = {
  date: '2020-09-30T23:39:27.060Z',
};

export  const defaul ={
  id: "/schema.json",
  type: "array",
  items: {
    $ref: "http://example.com/schema.json#/definitions/item"
  },
  definitions: {
    item: {
      type: "string"
    },
  },
}

export let initSchemajson = {
  id: "/SimplePerson",
  type: "object",
  properties: {
    name: {
      type: "string"
    },
    address: {
      $ref: "/SimpleAddress"
    },
    votes: {
      type: "integer", minimum: 1
    }
  }
}

export let schemavaldator = {
  items: {
    $ref: '#items'
  },
  definitions: {
    items: {
      $id: '#items',
      type: 'array',
    },
  },
};

export const  rewi ={
  // @ts-ignore
  rewrite: unmarshall
}

export let schemaunion = {
  type: "object",
  properties: {
    wildcards: {
      type: "array",
      items: {
        type: [{
          $ref: "MongoDb#ObjectId", title: "test", description: "test"
        }, {
          type: "string", pattern: "^\\*$"
        }]
      },
    },
  },
};

export let pre={
  // @ts-ignore
  preValidateProperty: preValidate

}

export let allowAttributes ={
  allowUnknownAttributes: true
}
export let skipAttribute ={
  skipAttributes: ["minimum"]
}
export let  Validate={
  type: 'array', items: {
    type: 'string'
  }
}
export let ANonArray={
  type: 'array'
}
export  let EqualToMinItems ={
  type: 'array', items: {
  type: 'number'
}, minItems: 2
}

export let DuplicateItem ={
  type: 'array', uniqueItems: true
}
export  let NotAnArray={
  type: 'any', uniqueItems: true
}
export  let  DuplicateObjects={a: 1}

export let oneOfSchemadata = {
  oneOf: [
    { type: 'string' },
    { enum: [0, 1] },
    { type: 'object', required: ['type'] },
    { type: 'object', required: ['name'] },
  ],
};
export let ValidNumber={
  type: 'number'
}
export  let finedInstance={
  type: 'number', required: true
}
export let  ValidateNull={
  type: 'null'
}
export let AnUndefined={
  type: 'date', required: true
}
export let provide={
  name: 'test', lines: ['1$']
}
export  let  AnUndefineddata={
  type: 'date'
}
export  let NonInteger ={
  type: 'integer'
}
export  let NonIntegerdata ={
  type: 'integer',required: true
}
export  let  dateTrue={
  type: 'boolean'
}
export let datetruedata= {
  type: 'boolean', required: true
}
export  let TrueAsAny={
  type: 'any'
}
export  let TrueAsAnydata={
  type: 'any',required: true
}
export   let schemaIgnore = {
  type: [undefined, "string"],
};
export let schemaErrorOnNull = {
  type: [null, "string"],
};

export let Success={
  type: true
}
export let Successdata ={
  type: true, name: true
}
export  let ErrorFlag={
  throwError: true
}
export let MeetsMinimum={
  type: 'number', minimum: '1'
}
export let clusiveMinimum ={
  type: 'number', minimum: '0', exclusiveMinimum: true
}
export let clusiveMinimumdata ={
  type: 'number', minimum: '0', exclusiveMinimum: true
}
export let TheMaximum={
  type: 'number', maximum: '2'
}
export let  TheMaximumda={
  type: 'number', maximum: 1
}
export let TheMinimum={
  type: 'number',minimum: 2
}
export let TheMaximumdata = {
  type: 'number', maximum: '2', exclusiveMaximum: true
}
export let TheMaximumtext = {
  type: 'number', maximum: 1, exclusiveMaximum: true
}
export let TheMinimumdata={
  type: 'number', minimum: 1, exclusiveMinimum: true
}
export let IsBelow={
  type: 'number', minimum: '1', maximum: '2'
}
export let IsEven ={
  type: 'number', divisibleBy: 2
}
export let WithDecimals={
  type: 'number', divisibleBy: 0.1
}
export let dateIf0Is= {
  type: 'number', multipleOf: 2
}
export let Pattern ={
  type: 'string', pattern: 'ab+c'
}
export let chesThe ={
  type: 'string', pattern: /ab+c/
}
export let arsing={
  type: 'string', pattern: /^a+$/
}
export  let eprecated={
  type: 'string', pattern: /0{1.3}/
}
export let ength ={
  type: 'string', minLength: 5
}
export let engthed ={
  type: 'string', minLength: 6
}
export let engthad ={
  type: 'string', minLength: 5
}
export let engthfour ={
  type: 'string', minLength: 4
}
export let engthfourdata ={
  type: 'string', minLength: 4
}
export let OneOfThe ={
  type: 'string', enum: ['abcdf', 'abcde']
}
export let oneofdad={
  type: 'string', enum: ['abcdf', 'abcdd']
}
export let ValidateIfNum={
  type: 'number', enum: [1, 2]
}
export let ValidateIf={
  enum: ['foo', 'bar', 'baz'], default: 'baz'
}
export let  defalut={
  enum: ['foo', 'bar', 'baz'], required: true, default: 'baz'
}
export  let asOmmite ={
  type: 'object', properties: {
    the_field: {
      enum: ['foo', 'bar', 'baz'], required: true
    }
  }
}
export let argument={
  type: 'array', items: {
    type: 'string', format: 'alphanumeric'
  }
}
export let filed={
  the_field: undefined
}
export let proper={
  type: 'object', properties: {
    the_field: {
      enum: ['foo', 'bar', 'baz']
    }
  }, required: ['the_field']
}
export  let fild={
  the_field: 'bar'
}
export let scrison={
  description: 'some text'
}
export let disallow={
  type: 'any', disallow: 'array'
}
export  let foodata={
  foo: 1
}
export let quux= {
  dependencies: {
    quux: ['foo', 'bar']
  }
}
export let footest= {
  quux: 1, foo: 1
}
export  let  foobar={
  quux: 1, foo: 1, bar: 1
}
export let  name={
  name: 'test2'
}
export  let namedata={
  name: 'test3'
}
export  let nametest={
  name1: 'test1', name2: 'test2'
}

export  let va =  { const: 'value' };

export  let objectdata={ const: { 'some key': [null, "1", 2, true] } };
export  let bjectValid={
  'some key': [null, "1", 2, true]
}
export let ectInvali={
  'some key': [false, "1", 2, true]
}
export let dateInval={
  disableFormat: true
}
export  let mixed={
  type: 'object',
  properties: {
    name: { type: 'string' },
    lines: {
      type: 'array',
      items: { type: 'string', format: 'alphanumeric' },
    },
  },
};
export let addschema ={
  id: 'http://example.com/base.json',
  items: {
    $ref: 'item.json',
  },
}
export let   addid={
  id: 'http://example.com/base.json'
}
export let   $addid={
  $id: 'http://example.com/base.json'
}
export let cataid ={
  id: 'main.json'
}
export let dataCollec={
  $ref: '/data_collection_schema.json'
}
export  let houldThrowAn={
  properties: {
    a: {
      id: 'http://example.com/schema.json', type: 'string'
    },
    b: {
      $id: 'http://example.com/schema.json', type: 'number'
    },
  },
}

export let ouldva={
  name: 'test', lines: ['1']
}

export let ouldvadata={
  type: 'object',
  properties: {
    name: {
      type: 'string'
    },
    lines: {
      type: 'array',
      items: {
        type: 'string'
      },
    },
  },
}

export let onstructor ={
  required: ['constructor'],
  properties: {
    constructor: { type: 'string' },
  },
};

export let nameobject  =  {
  name: 'test'
}

export let proobject= {
  type: 'object',
  properties: {
    name: {
      type: 'string'
    },
  },
}

export let constru={constructor: 'string'}
export let construdata={
  constructor: true
}
export let objectaddress= {
  name: 'test', address: 'someplace'
}
export  let objectproper= {
  type: 'object',
  properties: {
    name: {
      type: 'string'
    },
    address: {
      type: 'string'
    },
  },
}
export let nest= {
  name: 'test', nested: 'test2'
}
export let nesttext= {
  type: 'object',
  properties: {
    name: {
      type: 'string'
    },
    nested: {
      type: 'object'
    },
  },
}

export let baz={
  foo: {
    baz: 1
  }
}
export  let objectrequ=  {
  type: 'object',
  required: true,
  properties: {
    foo: {
      type: 'object',
      required: true,
      properties: {
        bar: {
          type: 'object', required: true
        },
        baz: {
          type: 'number', required: true
        },
      },
    },
  },
}
export  let objectneste={
  type: 'object',
  properties: {
    name: {
      type: 'string'
    },
    nested: {
      type: 'string'
    },
  },
  additionalProperties: false,
}
export let extra={
  name: 'test', nested: 'test2', extraProp: 1
}
export let objectaddition={
  type: 'object',
  properties: {
    name: {
      type: 'string'
    },
    nested: {
      type: 'string'
    },
  },
  additionalProperties: {
    type: 'number'
  },
}

export let extradata={
  name: 'test', nested: 'test2', extraProp: '1'
}

export let objectschema = {
  type: 'object',
  properties: {
    name: {
      type: 'string'
    },
    nested: undefined,
  },
  additionalProperties: {
    type: 'number'
  },
};
export let nestobj={
  name: 'test', nested: 2
}

export let additionalschema = {
  type: 'object',
  properties: {
    name: {
      type: 'string'
    },
    nested: null,
  },
  additionalProperties: {
    type: 'number'
  },
};
export  let ternProperschema = {
  type: 'object',
  patternProperties: {
    name: {
      type: 'string'
    },
    nested: undefined,
  },
  additionalProperties: {
    type: 'number'
  },
};


export let objectschemanull = {
  type: 'object',
  patternProperties: {
    name: {
      type: 'string'
    },
    nested: null,
  },
  additionalProperties: {
    type: 'number'
  },
};

export let wrong={
  // @ts-ignore
  wrong_root: payment
}

export let objectIdSchemadata= {
  type: "object",
  id: "MongoDb#ObjectId",
  description: "MongoDB ObjectID",
  properties: {
    id: { type: "string" },
    _bsontype: { type: "string" },
  },
};
export let unionschema = {
  type: 'object',
  required: true,
  properties: {
    frames: {
      type: 'array',
      required: true,
      items: {
        type: 'object',
        properties: {
          filename: { type: 'string', required: true },
          lineno: { type: ['integer', 'null'] },
          method: { type: ['string', 'null'] },
        },
      },
    },
    exception: {
      type: 'object',
      required: true,
      properties: {
        class: { type: 'string', required: true },
        message: { type: 'string' },
      },
    },
  },
};

export   let excdata = {
  class: 'testing...', message: 'this is only a test'
};

export let ForNumber ={type: ['number', 'string']}
export let ForNull ={
  type: ['null', 'string']
}

export let alidateFo={
  type: ['null', {
    $ref: 'Test#Simple'
  }]
}

export let alidate={
  type: [{
    type: 'string', pattern: '^\\*$'
  }, {
    $ref: 'Test#Num'
  }]
}
export   let  unitonschema = {
  type: "object",
  properties: {
    wildcards: {
      type: "array",
      items: {
        type: [{
          $ref: "MongoDb#ObjectId"
        }, {
          type: "string", pattern: "^\\*$"
        }]
      },
    },
  },
};

export  let orArra={
  wildcards: ['*']
}

export  let Emptyschema = {
  type: "object",
  properties: {
    wildcards: {
      type: "array",
      items: {
        type: [{
          $ref: "MongoDb#ObjectId"
        }, {
          type: "string", pattern: "^\\*$"
        }]
      },
    },
  },
};

export let mptysc ={
  wildcards: []
}

export  let wildcarschema = {
  type: "object",
  properties: {
    wildcards: {
      type: "array",
      items: {
        type: [{
          $ref: "MongoDb#ObjectId"
        }, {
          type: "string", pattern: "^\\*$"
        }]
      },
    },
  },
};

export let validtaschema = {
  type: 'number',
  oneMillionErrors: true,
};


export let validschema = {
  properties: {
    a: {
      type: 'number'
    },
    b:
    {
      type: 'number'
    },
  },
};
export let valid = {
  a: 0, b: 0
};
export let invalid = {
  a: null, b: null
};
export let worldinstance = {
  frames: [{
    filename: 'somefile.js', lineno: {
      hello: 'world'
    }
  }], exception: excdata
};

export  let nullinstance = {
  frames: [{
    filename: 'somefile.js', lineno: null
  }], exception: excdata
};
export let wildcard={
  wildcards: [{
    id: "1234", _bsontype: "test"
  }, '*']
}