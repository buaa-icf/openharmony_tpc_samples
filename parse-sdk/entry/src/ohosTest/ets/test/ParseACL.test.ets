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
import { ParseACL, ParseRole, ParseUser } from "@ohos/parser-sdk";

export default function parseACLTest() {
  describe('ParseACL', () => {
    it('can be constructed with no arguments', 0, () => {
      const a = new ParseACL();
      expect(a.permissionsById).assertDeepEquals({});
    });

    // it('can be constructed with a ParseUser', 0, () => {
    //   const u = new ParseUser();
    //   u.id = 'uid';
    //   const a = new ParseACL(u);
    //   expect(a.permissionsById).assertDeepEquals({ uid: { read: true, write: true } });
    // });

    it('can be constructed with a map of user IDs', 0, () => {
      const a = new ParseACL({ aUserId: { read: true, write: false } });
      expect(a.permissionsById).assertDeepEquals({
        aUserId: {
          read: true,
          write: false,
        },
      });
    });

    it('throws when constructed with an invalid permissions map', 0, () => {
      let err = () => {
        new ParseACL({ aUserId: { foo: true, bar: false } });
      };
      expect(err).assertThrowError('Tried to create an ACL with an invalid permission type.');
      err = () => {
        new ParseACL({ aUserId: { read: 12 } as ESObject });
      };
      expect(err).assertThrowError('Tried to create an ACL with an invalid permission value.');
    });

    it('throws a helpful error when constructed with a function', 0, () => {
      expect(() => {
        new ParseACL((() => {}) as ESObject);
      }).assertThrowError('ParseACL constructed with a function. Did you forget ()?');
    });

    // it('throws when setting an invalid user id', 0, () => {
    //   const a = new ParseACL();
    //   expect(a.setReadAccess.bind(a, 12, true)).assertThrowError('userId must be a string.');
    //
    //   expect(() => {
    //     a.getReadAccess(new ParseUser(), true);
    //   }).assertThrowError('Cannot get access for a ParseUser without an ID');
    // });

    it('throws when setting an invalid access', 0, () => {
      const a = new ParseACL();
      expect(a.setReadAccess.bind(a, 'aUserId', 12)).assertThrowError('allowed must be either true or false.');
    });

    // it('throws when role does not have name', 0, () => {
    //   const a = new ParseACL();
    //   expect(() => {
    //     a.setReadAccess(new ParseRole(), true);
    //   }).assertThrowError('Role must have a name');
    // });

    it('throws when setting an invalid role', 0, () => {
      const a = new ParseACL();
      expect(a.setRoleReadAccess.bind(a, 12, true)).assertThrowError('role must be a ParseRole or a String');
    });

    it('can be rendered to JSON format', 0, () => {
      const a = new ParseACL({ aUserId: { read: true, write: false } });
      expect(a.toJSON()).assertDeepEquals({
        aUserId: {
          read: true,
          write: false,
        },
      });
    });

    it('can set read access for a user', 0, () => {
      const a = new ParseACL();
      expect(a.permissionsById).assertDeepEquals({});

      // removing a permission that doesn't exist does nothing
      a.setReadAccess('aUserId', false);
      expect(a.permissionsById).assertDeepEquals({});

      a.setReadAccess('aUserId', true);
      expect(a.permissionsById).assertDeepEquals({
        aUserId: {
          read: true,
        },
      });

      a.setReadAccess('aUserId', false);
      expect(a.permissionsById).assertDeepEquals({});
    });

    it('can get read access for a user', 0, () => {
      const a = new ParseACL({
        aUserId: {
          read: true,
          write: false,
        },
      });
      expect(a.getReadAccess('aUserId')).assertTrue();
    });

    // it('can set write access for a user', 0, () => {
    //   const a = new ParseACL();
    //   const u = new ParseUser();
    //   u.id = 'aUserId';
    //
    //   expect(a.permissionsById).toEqual({});
    //
    //   // removing a permission that doesn't exist does nothing
    //   a.setWriteAccess('aUserId', false);
    //   expect(a.permissionsById).toEqual({});
    //
    //   a.setWriteAccess(u, false);
    //   expect(a.permissionsById).toEqual({});
    //
    //   a.setWriteAccess('aUserId', true);
    //   expect(a.permissionsById).toEqual({
    //     aUserId: {
    //       write: true,
    //     },
    //   });
    //
    //   a.setWriteAccess('aUserId', false);
    //   expect(a.permissionsById).toEqual({});
    //
    //   a.setWriteAccess(u, true);
    //   expect(a.permissionsById).toEqual({
    //     aUserId: {
    //       write: true,
    //     },
    //   });
    //
    //   a.setWriteAccess(u, false);
    //   expect(a.permissionsById).toEqual({});
    // });

    // it('can get write access for a user', () => {
    //   const a = new ParseACL({
    //     aUserId: {
    //       read: true,
    //       write: false,
    //     },
    //   });
    //
    //   const u = new ParseUser();
    //   u.id = 'aUserId';
    //
    //   expect(a.getWriteAccess('aUserId')).toBe(false);
    //   expect(a.getWriteAccess(u)).toBe(false);
    // });

    it('can set public read access', 0, () => {
      const a = new ParseACL();
      expect(a.permissionsById).assertDeepEquals({});
      expect(a.getPublicReadAccess()).assertFalse();

      a.setPublicReadAccess(true);
      expect(a.permissionsById).assertDeepEquals({
        '*': {
          read: true,
        },
      });
      expect(a.getPublicReadAccess()).assertTrue();

      a.setPublicReadAccess(false);
      expect(a.permissionsById).assertDeepEquals({});
    });

    it('can set public write access', 0, () => {
      const a = new ParseACL();
      expect(a.permissionsById).assertDeepEquals({});
      expect(a.getPublicWriteAccess()).assertFalse();

      a.setPublicWriteAccess(true);
      expect(a.permissionsById).assertDeepEquals({
        '*': {
          write: true,
        },
      });
      expect(a.getPublicWriteAccess()).assertTrue();

      a.setPublicWriteAccess(false);
      expect(a.permissionsById).assertDeepEquals({});
    });

    it('can get role read access', 0, () => {
      const a = new ParseACL({
        'role:admin': {
          read: true,
          write: true,
        },
      });

      expect(a.getRoleReadAccess('admin')).assertTrue();
      expect(a.getRoleReadAccess(new ParseRole('admin', new ParseACL()))).assertTrue();
      expect(a.getReadAccess(new ParseRole('admin', new ParseACL()))).assertTrue();
    });

    it('can get role write access', 0, () => {
      const a = new ParseACL({
        'role:admin': {
          read: true,
          write: true,
        },
      });

      expect(a.getRoleWriteAccess('admin')).assertTrue();
      expect(a.getRoleWriteAccess(new ParseRole('admin', new ParseACL()))).assertTrue();
      expect(a.getWriteAccess(new ParseRole('admin', new ParseACL()))).assertTrue();
    });

    it('throws when fetching an invalid role', 0, () => {
      const a = new ParseACL();
      expect(a.getRoleReadAccess.bind(null, 5)).assertThrowError('role must be a ParseRole or a String');
      expect(a.getRoleWriteAccess.bind(null, 5)).assertThrowError('role must be a ParseRole or a String');
    });

    it('can set role read access', 0, () => {
      const a = new ParseACL();

      expect(a.getRoleReadAccess('admin')).assertFalse();
      expect(a.getRoleReadAccess(new ParseRole('admin', new ParseACL()))).assertFalse();

      a.setRoleReadAccess('admin', true);
      expect(a.getRoleReadAccess('admin')).assertTrue();
      expect(a.getRoleWriteAccess('admin')).assertFalse();

      a.setRoleReadAccess(new ParseRole('admin', new ParseACL()), false);
      expect(a.getRoleReadAccess(new ParseRole('admin', new ParseACL()))).assertFalse();

      a.setReadAccess(new ParseRole('admin', new ParseACL()), true);
      expect(a.getReadAccess(new ParseRole('admin', new ParseACL()))).assertTrue();
    });

    it('can set role write access', 0, () => {
      const a = new ParseACL();

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

    it('can test equality against another ACL', 0, () => {
      const a = new ParseACL();
      const b = new ParseACL();

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
      expect(a.equals(new ParseACL())).assertTrue();

      a.setReadAccess('aUserId', true);
      b.setReadAccess('aUserId', true);
      expect(a.equals(b)).assertTrue();
      expect(b.equals(a)).assertTrue();

      a.setWriteAccess('aUserId', true);
      b.setWriteAccess('aUserId', true);
      expect(a.equals(b)).assertTrue();
      expect(b.equals(a)).assertTrue();

      a.setWriteAccess('anotherUserId', true);
      expect(a.equals(b)).assertFalse();
      expect(b.equals(a)).assertFalse();

      b.setWriteAccess('anotherUserId', true);
      expect(a.equals(b)).assertTrue();
      expect(b.equals(a)).assertTrue();

      a.setPublicReadAccess(true);
      a.setReadAccess('aUserId', true);
      b.setReadAccess('aUserId', true);
      expect(a.equals(b)).assertFalse();
      expect(b.equals(a)).assertFalse();
      expect(a.equals(new ParseACL())).assertFalse();

      b.setWriteAccess('newUserId', true);
      expect(a.equals(b)).assertFalse();

      a.setPublicReadAccess(false);
      a.permissionsById.newUserId = { write: false };
      expect(a.equals(b)).assertFalse();
    });
  });
}