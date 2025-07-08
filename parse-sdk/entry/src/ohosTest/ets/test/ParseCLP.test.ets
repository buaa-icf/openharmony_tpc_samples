/*
  * Copyright (c) 2025 Huawei Device Co., Ltd.
  *
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
import { describe, expect, it } from "@ohos/hypium";
import { ParseACL, ParseCLP, ParseRole } from "@ohos/parser-sdk";

function generateReadCLP(key: ESObject): ESObject {
  return {
    get: { key: true } as ESObject,
    find: { key: true } as ESObject,
    count: { key: true } as ESObject,
    create: {} as ESObject,
    update: {} as ESObject,
    delete: {} as ESObject,
    addField: {} as ESObject,
    protectedFields: {} as ESObject,
  };
}

function generateWriteCLP(key: ESObject): ESObject {
  return {
    get: {} as ESObject,
    find: {} as ESObject,
    count: {} as ESObject,
    create: { key: true } as ESObject,
    update: { key: true } as ESObject,
    delete: { key: true } as ESObject,
    addField: { key: true } as ESObject,
    protectedFields: {} as ESObject,
  };
}

const DEFAULT_CLP: ESObject = {
  get: {} as ESObject,
  find: {} as ESObject,
  count: {} as ESObject,
  create: {} as ESObject,
  update: {} as ESObject,
  delete: {} as ESObject,
  addField: {} as ESObject,
  protectedFields: {} as ESObject,
};

const READ_CLP: ESObject = generateReadCLP('uid');
const WRITE_CLP: ESObject= generateWriteCLP('uid');
const PUBLIC_READ_CLP: ESObject = generateReadCLP('*');
const PUBLIC_WRITE_CLP: ESObject = generateWriteCLP('*');
const ROLE_READ_CLP: ESObject = generateReadCLP('role:admin');
const ROLE_WRITE_CLP: ESObject = generateWriteCLP('role:admin');

export default function parseCLPTest() {
  describe('ParseCLP', () => {
    it('can be constructed with no arguments', 0, () => {
      const a = new ParseCLP({});
      expect(a.permissionsMap).assertDeepEquals(DEFAULT_CLP);
    });

    // it('can be constructed with a ParseUser', 0, () => {
    //   const u = new ParseUser();
    //   u.id = 'uid';
    //   const a = new ParseCLP(u);
    //   expect(a.permissionsMap).toEqual({
    //     get: { uid: true },
    //     find: { uid: true },
    //     count: { uid: true },
    //     create: { uid: true },
    //     update: { uid: true },
    //     delete: { uid: true },
    //     addField: { uid: true },
    //     protectedFields: {},
    //   });
    // });

    it('can be constructed with a map of user IDs', 0, () => {
      const userCLP: ESObject = {
        get: { uid: true } as ESObject,
        find: { uid: true } as ESObject,
        count: { uid: true } as ESObject,
        create: { uid: true } as ESObject,
        update: { uid: true } as ESObject,
        delete: { uid: true } as ESObject,
        addField: { uid: true } as ESObject,
        protectedFields: {} as ESObject,
      };
      const a = new ParseCLP(userCLP);
      expect(a.permissionsMap).assertDeepEquals(userCLP);
    });

    it('throws when constructed with an invalid permissions map', 0, () => {
      let err = () => {
        new ParseCLP({ foobar: { foo: true, bar: false } });
      };
      expect(err).assertThrowError('Tried to create an CLP with an invalid permission type.');
      err = () => {
        new ParseCLP({ get: { uid: 12 } });
      };
      expect(err).assertThrowError('Tried to create an CLP with an invalid permission value.');
    });

    it('throws a helpful error when constructed with a function', 0, () => {
      expect(() => {
        new ParseCLP((() => {}) as ESObject);
      }).assertThrowError('ParseCLP constructed with a function. Did you forget ()?');
    });

    it('throws when setting an invalid input', 0, () => {
      const a = new ParseCLP({});
      expect(a.setReadAccess.bind(a, 12, true)).assertThrowError('userId must be a string.');
    });

    // it('throws when getting an invalid user id', 0, () => {
    //   const u = new ParseUser();
    //   const a = new ParseCLP();
    //   expect(a.getReadAccess.bind(a, u)).toThrow('Cannot get access for a Parse.User without an id.');
    // });

    it('throws when setting an invalid access', 0, () => {
      const a = new ParseCLP({});
      expect(a.setReadAccess.bind(a, 'uid', 12)).assertThrowError('allowed must be either true or false.');
    });

    it('throws when setting an invalid role', 0, () => {
      const a = new ParseCLP({});
      expect(a.setRoleReadAccess.bind(a, 12, true)).assertThrowError('role must be a Parse.Role or a String');
      expect(a.setRoleWriteAccess.bind(a, 12, true)).assertThrowError('role must be a Parse.Role or a String');
    });

    // it('throws when setting an invalid protectedFields', () => {
    //   const a = new ParseCLP();
    //   const u = new ParseUser();
    //   const r = new ParseRole();
    //   expect(a.setProtectedFields.bind(a, 12)).toThrow('userId must be a string.');
    //   expect(a.setProtectedFields.bind(a, u)).toThrow(
    //     'Cannot get access for a Parse.User without an id.'
    //   );
    //   expect(a.setProtectedFields.bind(a, r)).toThrow('role must be a Parse.Role or a String');
    //   expect(a.setProtectedFields.bind(a, new ParseRole('admin'), 'not_field_array')).toThrow(
    //     'fields must be an array of strings or undefined.'
    //   );
    // });

    it('throws when setting an invalid group pointer permissions', 0, () => {
      const a = new ParseCLP({});
      expect(a.setReadUserFields.bind(a, 12)).assertThrowError(
        'readUserFields.pointerFields must be an array of strings or undefined.'
      );
      expect(a.setWriteUserFields.bind(a, 12)).assertThrowError(
        'writeUserFields.pointerFields must be an array of strings or undefined.'
      );

      const clp: ESObject = {
        get: {} as ESObject,
        find: {} as ESObject,
        count: {} as ESObject,
        create: {} as ESObject,
        update: {} as ESObject,
        delete: {} as ESObject,
        addField: {} as ESObject,
        protectedFields: {} as ESObject,
        readUserFields: [1234],
        writeUserFields: ['owner'],
      };
      expect(() => {
        new ParseCLP(clp);
      }).assertThrowError('Tried to create an CLP with an invalid permission value.');
    });

    it('can be rendered to JSON format', 0, () => {
      const permissionsMap: ESObject = {
        get: { uid: true } as ESObject,
        find: { uid: true } as ESObject,
        count: { uid: true } as ESObject,
        create: { admin: true } as ESObject,
        update: { admin: true } as ESObject,
        delete: { admin: true } as ESObject,
        addField: { admin: true } as ESObject,
        protectedFields: { admin: ['objectId', 'field1'] } as ESObject,
      };
      const a = new ParseCLP(permissionsMap);
      expect(a.toJSON()).assertDeepEquals(permissionsMap);
    });

    it('can set protectedFields', 0, () => {
      const a = new ParseCLP({});
      const r = new ParseRole('admin', new ParseACL());

      expect(a.permissionsMap).assertDeepEquals(DEFAULT_CLP);

      a.setProtectedFields('uid', ['admin']);
      a.setPublicProtectedFields(['foo']);
      a.setRoleProtectedFields(r, ['bar']);

      expect(a.toJSON()).assertDeepEquals({
        get: {},
        find: {},
        count: {},
        create: {},
        update: {},
        delete: {},
        addField: {},
        protectedFields: {
          uid: ['admin'],
          '*': ['foo'],
          'role:admin': ['bar'],
        },
      });
      expect(a.getProtectedFields('uid')).assertDeepEquals(['admin']);
      expect(a.getPublicProtectedFields()).assertDeepEquals(['foo']);
      expect(a.getRoleProtectedFields(r)).assertDeepEquals(['bar']);

      a.setProtectedFields('uid', undefined);
      a.setPublicProtectedFields(undefined);
      a.setRoleProtectedFields(r, undefined);
      expect(a.toJSON()).assertDeepEquals(DEFAULT_CLP);
    });

    // it('can get and set requiresAuthentication', 0, () => {
    //   const a = new ParseCLP({});
    //   a.setGetRequiresAuthentication(true);
    //   expect(a.toJSON()).toEqual({
    //     get: { requiresAuthentication: true },
    //     find: {},
    //     count: {},
    //     create: {},
    //     update: {},
    //     delete: {},
    //     addField: {},
    //     protectedFields: {},
    //   });
    //   expect(a.getGetRequiresAuthentication()).toBe(true);
    //   a.setGetRequiresAuthentication(false);
    //   expect(a.toJSON()).toEqual(DEFAULT_CLP);
    // });

    // it('can get and set pointerFields', 0, () => {
    //   const testCLP = {
    //     get: { pointerFields: ['owner'] },
    //     find: {},
    //     count: {},
    //     create: {},
    //     update: {},
    //     delete: {},
    //     addField: {},
    //     protectedFields: {},
    //   };
    //   const pointerCLP = new ParseCLP(testCLP);
    //   expect(pointerCLP.toJSON()).toEqual(testCLP);
    //
    //   const a = new ParseCLP();
    //   a.setGetPointerFields(['owner']);
    //   expect(a.toJSON()).toEqual(testCLP);
    //   expect(a.getGetPointerFields()).toEqual(['owner']);
    //
    //   a.setGetPointerFields(undefined);
    //   expect(a.toJSON()).toEqual(DEFAULT_CLP);
    //   expect(a.getGetPointerFields()).toEqual(undefined);
    // });

    it('can get and set group pointer permissions', 0, () => {
      const testCLP: ESObject = {
        get: {} as ESObject,
        find: {} as ESObject,
        count: {} as ESObject,
        create: {} as ESObject,
        update: {} as ESObject,
        delete: {} as ESObject,
        addField: {} as ESObject,
        protectedFields: {} as ESObject,
        readUserFields: ['parent'],
        writeUserFields: ['owner'],
      };
      const groupCLP = new ParseCLP(testCLP);
      expect(groupCLP.toJSON()).assertDeepEquals(testCLP);

      const a = new ParseCLP({});
      a.setWriteUserFields(['owner']);
      a.setReadUserFields(['parent']);
      expect(a.toJSON()).assertDeepEquals(testCLP);
      expect(a.getWriteUserFields()).assertDeepEquals(['owner']);
      expect(a.getReadUserFields()).assertDeepEquals(['parent']);

      a.setWriteUserFields(undefined);
      a.setReadUserFields(undefined);
      expect(a.toJSON()).assertDeepEquals(DEFAULT_CLP);
    });

    // it('can set read access', 0, () => {
    //   const a = new ParseCLP();
    //   expect(a.permissionsMap).toEqual(DEFAULT_CLP);
    //
    //   a.setReadAccess('uid', false);
    //   expect(a.permissionsMap).toEqual(DEFAULT_CLP);
    //   expect(a.getReadAccess('uid')).toBe(false);
    //
    //   a.setReadAccess('uid', true);
    //   expect(a.permissionsMap).toEqual(READ_CLP);
    //   expect(a.getReadAccess('uid')).toBe(true);
    //
    //   a.setReadAccess('uid', false);
    //   expect(a.permissionsMap).toEqual(DEFAULT_CLP);
    //   expect(a.getReadAccess('uid')).toBe(false);
    //
    //   const u = new ParseUser();
    //   u.id = 'uid';
    //
    //   a.setReadAccess(u, false);
    //   expect(a.permissionsMap).toEqual(DEFAULT_CLP);
    //   expect(a.getReadAccess(u)).toBe(false);
    //
    //   a.setReadAccess(u, true);
    //   expect(a.permissionsMap).toEqual(READ_CLP);
    //   expect(a.getReadAccess(u)).toBe(true);
    //
    //   a.setReadAccess(u, false);
    //   expect(a.permissionsMap).toEqual(DEFAULT_CLP);
    //   expect(a.getReadAccess(u)).toBe(false);
    // });

    // it('can get read access', 0, () => {
    //   const a = new ParseCLP({});
    //   a.setGetAccess('uid', true);
    //   a.setFindAccess('uid', true);
    //   a.setCountAccess('uid', true);
    //   expect(a.toJSON()).toEqual(READ_CLP);
    //   expect(a.getReadAccess('uid')).toBe(true);
    //   expect(a.getGetAccess('uid')).toBe(true);
    //   expect(a.getFindAccess('uid')).toBe(true);
    //   expect(a.getCountAccess('uid')).toBe(true);
    //   a.setGetAccess('uid', false);
    //   a.setFindAccess('uid', false);
    //   a.setCountAccess('uid', false);
    //   expect(a.getReadAccess('uid')).toBe(false);
    //   expect(a.getGetAccess('uid')).toBe(false);
    //   expect(a.getFindAccess('uid')).toBe(false);
    //   expect(a.getCountAccess('uid')).toBe(false);
    //   expect(a.toJSON()).toEqual(DEFAULT_CLP);
    // });

    // it('can set write access', () => {
    //   const a = new ParseCLP();
    //   expect(a.permissionsMap).toEqual(DEFAULT_CLP);
    //
    //   a.setWriteAccess('uid', false);
    //   expect(a.permissionsMap).toEqual(DEFAULT_CLP);
    //   expect(a.getWriteAccess('uid')).toBe(false);
    //
    //   a.setWriteAccess('uid', true);
    //   expect(a.permissionsMap).toEqual(WRITE_CLP);
    //   expect(a.getWriteAccess('uid')).toBe(true);
    //
    //   a.setWriteAccess('uid', false);
    //   expect(a.permissionsMap).toEqual(DEFAULT_CLP);
    //   expect(a.getWriteAccess('uid')).toBe(false);
    //
    //   const u = new ParseUser();
    //   u.id = 'uid';
    //
    //   a.setWriteAccess(u, false);
    //   expect(a.permissionsMap).toEqual(DEFAULT_CLP);
    //   expect(a.getWriteAccess(u)).toBe(false);
    //
    //   a.setWriteAccess(u, true);
    //   expect(a.permissionsMap).toEqual(WRITE_CLP);
    //   expect(a.getWriteAccess(u)).toBe(true);
    //
    //   a.setWriteAccess(u, false);
    //   expect(a.permissionsMap).toEqual(DEFAULT_CLP);
    //   expect(a.getWriteAccess(u)).toBe(false);
    // });

    // it('can get write access', () => {
    //   const a = new ParseCLP({});
    //   a.setCreateAccess('uid', true);
    //   a.setDeleteAccess('uid', true);
    //   a.setUpdateAccess('uid', true);
    //   a.setAddFieldAccess('uid', true);
    //   expect(a.toJSON()).toEqual(WRITE_CLP);
    //   expect(a.getWriteAccess('uid')).toBe(true);
    //   expect(a.getCreateAccess('uid')).toBe(true);
    //   expect(a.getDeleteAccess('uid')).toBe(true);
    //   expect(a.getUpdateAccess('uid')).toBe(true);
    //   expect(a.getAddFieldAccess('uid')).toBe(true);
    //   a.setCreateAccess('uid', false);
    //   a.setDeleteAccess('uid', false);
    //   a.setUpdateAccess('uid', false);
    //   a.setAddFieldAccess('uid', false);
    //   expect(a.getWriteAccess('uid')).toBe(false);
    //   expect(a.getCreateAccess('uid')).toBe(false);
    //   expect(a.getDeleteAccess('uid')).toBe(false);
    //   expect(a.getUpdateAccess('uid')).toBe(false);
    //   expect(a.getAddFieldAccess('uid')).toBe(false);
    //   expect(a.toJSON()).toEqual(DEFAULT_CLP);
    // });

    // it('can handle public access', () => {
    //   const a = new ParseCLP();
    //   expect(a.permissionsMap).toEqual(DEFAULT_CLP);
    //   expect(a.getPublicReadAccess()).toBe(false);
    //   expect(a.getPublicWriteAccess()).toBe(false);
    //
    //   a.setPublicGetAccess(true);
    //   a.setPublicFindAccess(true);
    //   a.setPublicCountAccess(true);
    //   expect(a.toJSON()).toEqual(PUBLIC_READ_CLP);
    //   expect(a.getPublicReadAccess()).toBe(true);
    //   expect(a.getPublicGetAccess()).toBe(true);
    //   expect(a.getPublicFindAccess()).toBe(true);
    //   expect(a.getPublicCountAccess()).toBe(true);
    //
    //   a.setPublicReadAccess(false);
    //   expect(a.toJSON()).toEqual(DEFAULT_CLP);
    //   expect(a.getPublicReadAccess()).toBe(false);
    //   expect(a.getPublicGetAccess()).toBe(false);
    //   expect(a.getPublicFindAccess()).toBe(false);
    //   expect(a.getPublicCountAccess()).toBe(false);
    //
    //   a.setPublicCreateAccess(true);
    //   a.setPublicDeleteAccess(true);
    //   a.setPublicUpdateAccess(true);
    //   a.setPublicAddFieldAccess(true);
    //   expect(a.toJSON()).toEqual(PUBLIC_WRITE_CLP);
    //   expect(a.getPublicWriteAccess()).toBe(true);
    //   expect(a.getPublicCreateAccess()).toBe(true);
    //   expect(a.getPublicDeleteAccess()).toBe(true);
    //   expect(a.getPublicUpdateAccess()).toBe(true);
    //   expect(a.getPublicAddFieldAccess()).toBe(true);
    //
    //   a.setPublicWriteAccess(false);
    //   expect(a.toJSON()).toEqual(DEFAULT_CLP);
    //   expect(a.getPublicWriteAccess()).toBe(false);
    //   expect(a.getPublicCreateAccess()).toBe(false);
    //   expect(a.getPublicDeleteAccess()).toBe(false);
    //   expect(a.getPublicUpdateAccess()).toBe(false);
    //   expect(a.getPublicAddFieldAccess()).toBe(false);
    //
    //   const w = new ParseCLP();
    //   w.setPublicWriteAccess(true);
    //   expect(w.toJSON()).toEqual(PUBLIC_WRITE_CLP);
    //
    //   const r = new ParseCLP();
    //   r.setPublicReadAccess(true);
    //   expect(r.toJSON()).toEqual(PUBLIC_READ_CLP);
    // });

    it('can get clp with role', 0, () => {
      const role = new ParseRole('admin', new ParseACL());
      const a = new ParseCLP(role);

      expect(a.toJSON()).assertDeepEquals({
        get: { 'role:admin': true },
        find: { 'role:admin': true },
        count: { 'role:admin': true },
        create: { 'role:admin': true },
        update: { 'role:admin': true },
        delete: { 'role:admin': true },
        addField: { 'role:admin': true },
        protectedFields: {},
      });
      expect(a.getRoleReadAccess('admin')).assertTrue();
      expect(a.getRoleReadAccess(role)).assertTrue();
      expect(a.getReadAccess(role)).assertTrue();
    });

    it('can get role read access', 0, () => {
      const a = new ParseCLP({
        get: { 'role:admin': true },
        find: { 'role:admin': true },
        count: { 'role:admin': true },
        create: { 'role:admin': true },
        update: { 'role:admin': true },
        delete: { 'role:admin': true },
        addField: { 'role:admin': true },
        protectedFields: { 'role:admin': [] },
      });

      expect(a.getRoleReadAccess('admin')).assertTrue();
      expect(a.getRoleReadAccess(new ParseRole('admin', new ParseACL()))).assertTrue();
      expect(a.getReadAccess(new ParseRole('admin', new ParseACL()))).assertTrue();
    });

    it('can get role write access', 0, () => {
      const a = new ParseCLP({
        get: { 'role:admin': true },
        find: { 'role:admin': true },
        count: { 'role:admin': true },
        create: { 'role:admin': true },
        update: { 'role:admin': true },
        delete: { 'role:admin': true },
        addField: { 'role:admin': true },
        protectedFields: { 'role:admin': [] },
      });

      expect(a.getRoleWriteAccess('admin')).assertTrue();
      expect(a.getRoleWriteAccess(new ParseRole('admin', new ParseACL()))).assertTrue();
      expect(a.getWriteAccess(new ParseRole('admin', new ParseACL()))).assertTrue();
    });

    it('can set role read access', 0, () => {
      const a = new ParseCLP({});
      const adminRole = new ParseRole('admin', new ParseACL());

      expect(a.getRoleReadAccess('admin')).assertFalse();
      expect(a.getRoleReadAccess(adminRole)).assertFalse();

      a.setRoleReadAccess('admin', true);
      expect(a.getRoleReadAccess('admin')).assertTrue();
      expect(a.getRoleWriteAccess('admin')).assertFalse();

      a.setRoleReadAccess(adminRole, false);
      expect(a.getRoleReadAccess(adminRole)).assertFalse();

      a.setReadAccess(adminRole, true);
      expect(a.getReadAccess(adminRole)).assertTrue();
    });

    it('can set role write access', 0, () => {
      const a = new ParseCLP({});

      expect(a.getRoleWriteAccess('admin')).assertFalse();
      expect(a.getRoleWriteAccess(new ParseRole('admin', new ParseACL()))).assertFalse();

      a.setRoleWriteAccess('admin', true);
      expect(a.getRoleWriteAccess('admin')).assertTrue();
      expect(a.getRoleReadAccess('admin')).assertFalse();

      a.setRoleWriteAccess(new ParseRole('admin', new ParseACL()), false);
      expect(a.getRoleWriteAccess(new ParseRole('admin', new ParseACL()))).assertFalse();

      a.setWriteAccess(new ParseRole('admin', new ParseACL()), true);
      expect(a.getWriteAccess(new ParseRole('admin', new ParseACL()))).assertTrue();
    });

    // it('can handle role access', () => {
    //   const a = new ParseCLP();
    //   const r = new ParseRole('admin');
    //
    //   expect(a.permissionsMap).toEqual(DEFAULT_CLP);
    //   expect(a.getRoleReadAccess(r)).toBe(false);
    //   expect(a.getRoleWriteAccess(r)).toBe(false);
    //
    //   a.setRoleGetAccess(r, true);
    //   a.setRoleFindAccess(r, true);
    //   a.setRoleCountAccess(r, true);
    //   expect(a.toJSON()).toEqual(ROLE_READ_CLP);
    //   expect(a.getRoleReadAccess(r)).toBe(true);
    //   expect(a.getRoleGetAccess(r)).toBe(true);
    //   expect(a.getRoleFindAccess(r)).toBe(true);
    //   expect(a.getRoleCountAccess(r)).toBe(true);
    //
    //   a.setRoleReadAccess(r, false);
    //   expect(a.toJSON()).toEqual(DEFAULT_CLP);
    //   expect(a.getRoleReadAccess(r)).toBe(false);
    //   expect(a.getRoleGetAccess(r)).toBe(false);
    //   expect(a.getRoleFindAccess(r)).toBe(false);
    //   expect(a.getRoleCountAccess(r)).toBe(false);
    //
    //   a.setRoleCreateAccess(r, true);
    //   a.setRoleDeleteAccess(r, true);
    //   a.setRoleUpdateAccess(r, true);
    //   a.setRoleAddFieldAccess(r, true);
    //   expect(a.toJSON()).toEqual(ROLE_WRITE_CLP);
    //   expect(a.getRoleWriteAccess(r)).toBe(true);
    //   expect(a.getRoleCreateAccess(r)).toBe(true);
    //   expect(a.getRoleDeleteAccess(r)).toBe(true);
    //   expect(a.getRoleUpdateAccess(r)).toBe(true);
    //   expect(a.getRoleAddFieldAccess(r)).toBe(true);
    //
    //   a.setRoleWriteAccess(r, false);
    //   expect(a.toJSON()).toEqual(DEFAULT_CLP);
    //   expect(a.getRoleWriteAccess(r)).toBe(false);
    //   expect(a.getRoleCreateAccess(r)).toBe(false);
    //   expect(a.getRoleDeleteAccess(r)).toBe(false);
    //   expect(a.getRoleUpdateAccess(r)).toBe(false);
    //   expect(a.getRoleAddFieldAccess(r)).toBe(false);
    //
    //   const b = new ParseCLP();
    //   b.setRoleWriteAccess(r, true);
    //   expect(b.toJSON()).toEqual(ROLE_WRITE_CLP);
    //
    //   const c = new ParseCLP();
    //   c.setRoleReadAccess(r, true);
    //   expect(c.toJSON()).toEqual(ROLE_READ_CLP);
    // });

    it('can test equality against another CLP', 0, () => {
      const a = new ParseCLP({});
      const b = new ParseCLP({});

      expect(a.equals(a)).assertTrue();
      expect(a.equals(b)).assertTrue();
      expect(b.equals(a)).assertTrue();

      a.setPublicReadAccess(true);
      expect(a.equals(a)).assertTrue();
      expect(a.equals(b)).assertFalse();
      expect(b.equals(a)).assertFalse();

      b.setPublicWriteAccess(true);
      expect(b.equals(b)).assertTrue();
      expect(a.equals(b)).assertFalse();
      expect(b.equals(a)).assertFalse();

      a.setPublicWriteAccess(true);
      b.setPublicReadAccess(true);
      expect(a.equals(b)).assertTrue();
      expect(b.equals(a)).assertTrue();

      a.setPublicReadAccess(false);
      a.setPublicWriteAccess(false);
      b.setPublicReadAccess(false);
      b.setPublicWriteAccess(false);
      expect(a.equals(b)).assertTrue();
      expect(b.equals(a)).assertTrue();
      expect(a.equals(new ParseCLP({}))).assertTrue();

      a.setReadAccess('uid', true);
      b.setReadAccess('uid', true);
      expect(a.equals(b)).assertTrue();
      expect(b.equals(a)).assertTrue();

      a.setWriteAccess('uid', true);
      b.setWriteAccess('uid', true);
      expect(a.equals(b)).assertTrue();
      expect(b.equals(a)).assertTrue();

      a.setWriteAccess('uid2', true);
      expect(a.equals(b)).assertFalse();
      expect(b.equals(a)).assertFalse();

      b.setWriteAccess('uid2', true);
      expect(a.equals(b)).assertTrue();
      expect(b.equals(a)).assertTrue();

      a.setPublicReadAccess(true);
      a.setReadAccess('uid', true);
      b.setReadAccess('uid', true);
      expect(a.equals(b)).assertFalse();
      expect(b.equals(a)).assertFalse();

      b.setReadAccess('uid2', true);
      expect(a.equals(b)).assertFalse();
      expect(b.equals(a)).assertFalse();

      b.setReadAccess('uid2', false);
      b.setPublicReadAccess(true);
      b.permissionsMap.get['*'] = 'HACKED';
      expect(a.equals(b)).assertFalse();
      expect(b.equals(a)).assertFalse();

      const r = new ParseRole('admin', new ParseACL());
      expect(a.equals(r as ESObject)).assertFalse();

      const hacked = new ParseCLP({});

      hacked.permissionsMap.newPermission = {};
      expect(a.equals(hacked)).assertFalse();
      expect(hacked.equals(a)).assertFalse();
    });
  });
}