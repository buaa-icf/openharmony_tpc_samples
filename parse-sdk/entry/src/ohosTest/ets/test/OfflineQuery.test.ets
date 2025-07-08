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

import { describe, expect, it } from '@ohos/hypium';
import {
  ParseObject,
  ParseQuery,
  OfflineQuery,
  ParseGeoPoint,
  ParseUser,
  ParsePolygon,
  ParseError
} from '@ohos/parser-sdk';

export default function offlineQueryTest() {

  describe('offlineQueryTest', () => {
    it('matches blank queries', 0, () => {
      const obj = new ParseObject('Item');
      const q = new ParseQuery('Item');
      expect(OfflineQuery.matchesQuery(q.className, obj, [], q)).assertEqual(true);
      expect(OfflineQuery.matchesQuery(q.className, obj._toFullJSON(), [], q.toJSON().where)).assertEqual(true);
    });

    it('can handle unknown query', 0, () => {
      const obj = new ParseObject('Item');
      const q = new ParseQuery('Item');
      q._addCondition('key', 'unknown', 'value');
      expect(OfflineQuery.matchesQuery(q.className, obj, [], q)).assertEqual(false);
      expect(OfflineQuery.matchesQuery(q.className, obj._toFullJSON(), [], q.toJSON().where)).assertEqual(false);
    });

    it('matches queries null field', 0, () => {
      const obj = new ParseObject('Item');
      const q = new ParseQuery('Item');
      q.equalTo('field', null);
      expect(OfflineQuery.matchesQuery(q.className, obj, [], q)).assertEqual(false);
    });

    it('matches queries invalid key', 0, () => {
      const obj = new ParseObject('Item');
      const q = new ParseQuery('Item');
      q.equalTo('$foo', 'bar');
      try {
        OfflineQuery.matchesQuery(q.className, obj, [], q);
      } catch (e) {
        expect(e.message).assertEqual('Invalid Key: $foo');
      }
    });

    it('matches queries date field', 0, () => {
      const date = new Date();
      const obj = new ParseObject('Item');
      obj.set('field', date);
      const q = new ParseQuery('Item');
      q.greaterThanOrEqualTo('field', date);
      expect(OfflineQuery.matchesQuery(q.className, obj, [], q)).assertEqual(true);
    });

    it('matches queries relativeTime date field', 0, () => {
      const now = Date.now();
      const obj: ESObject = new ParseObject('Item', {
        name: 'obj1',
        ttl: new Date(now + 2 * 24 * 60 * 60 * 1000), // 2 days from now
      } as ESObject);

      let q = new ParseQuery('Item');
      q.greaterThan('ttl', { $relativeTime: 'in 1 day' });
      expect(OfflineQuery.matchesQuery(q.className, obj, [], q)).assertEqual(true);

      q = new ParseQuery('Item');
      q.greaterThan('ttl', { $relativeTime: '1 day ago' });
      expect(OfflineQuery.matchesQuery(q.className, obj, [], q)).assertEqual(true);

      q = new ParseQuery('Item');
      q.lessThan('ttl', { $relativeTime: '5 days ago' });
      expect(OfflineQuery.matchesQuery(q.className, obj, [], q)).assertEqual(false);

      q = new ParseQuery('Item');
      q.lessThan('ttl', { $relativeTime: '0 yr 0 wk 5 d 0 hr 0 min 0 sec ago' });
      expect(OfflineQuery.matchesQuery(q.className, obj, [], q)).assertEqual(false);

      q = new ParseQuery('Item');
      q.greaterThan('ttl', { $relativeTime: 'now' });
      expect(OfflineQuery.matchesQuery(q.className, obj, [], q)).assertEqual(true);

      q = new ParseQuery('Item');
      q.greaterThan('ttl', { $relativeTime: 'now' });
      q.lessThan('ttl', { $relativeTime: 'in 3 day' });
      expect(OfflineQuery.matchesQuery(q.className, obj, [], q)).assertEqual(true);

      q = new ParseQuery('Item');
      q.greaterThan('ttl', { $relativeTime: '1 years 3 weeks 1 hours 3 minutes 2 seconds ago' });
      expect(OfflineQuery.matchesQuery(q.className, obj, [], q)).assertEqual(true);

      q = new ParseQuery('Item');
      q.greaterThan('ttl', { $relativeTime: '2 year 2 week 1 hour 4 day 3 minute 2 second ago' });
      expect(OfflineQuery.matchesQuery(q.className, obj, [], q)).assertEqual(true);

      q = new ParseQuery('Item');
      q.greaterThan('ttl', { $relativeTime: '2 yrs 2 wks 1 hrs 3 mins 2 secs ago' });
      expect(OfflineQuery.matchesQuery(q.className, obj, [], q)).assertEqual(true);

      q = new ParseQuery('Item');
      q.greaterThan('ttl', { $relativeTime: '0 yr 0 wk 0 d 24 hr 3 min 2 sec ago' });
      expect(OfflineQuery.matchesQuery(q.className, obj, [], q)).assertEqual(true);
    });

    it('matches invalid queries relativeTime date field', 0, () => {
      const date = new Date('1995-12-17T03:24:00');
      const obj = new ParseObject('Item');
      obj.set('field', date);
      const q = new ParseQuery('Item');
      q.equalTo('field', { $relativeTime: 'in 0 day' });
      expect(OfflineQuery.matchesQuery(q.className, obj, [], q)).assertEqual(false);
    });

    it('handles invalid queries relativeTime date errors', 0, () => {
      const obj = new ParseObject('Item');
      obj.set('field', new Date('1995-12-17T03:24:00'));

      const q = new ParseQuery('Item');
      q.greaterThan('field', { $relativeTime: '1 unknown ago' });
      expect((): ESObject => OfflineQuery.matchesQuery(q.className, obj, [], q)).assertThrowError(
        "bad $relativeTime (field) value. Invalid interval: 'unknown'"
      );

      q.greaterThan('field', { $relativeTime: 'in 1 ago' });
      expect((): ESObject => OfflineQuery.matchesQuery(q.className, obj, [], q)).assertThrowError(
        "bad $relativeTime (field) value. Time cannot have both 'in' and 'ago'"
      );

      q.greaterThan('field', { $relativeTime: 'ago 1 in' });
      expect((): ESObject => OfflineQuery.matchesQuery(q.className, obj, [], q)).assertThrowError(
        "bad $relativeTime (field) value. Time should either start with 'in' or end with 'ago'"
      );

      q.greaterThan('field', { $relativeTime: '1 ago' });
      expect((): ESObject => OfflineQuery.matchesQuery(q.className, obj, [], q)).assertThrowError(
        'bad $relativeTime (field) value. Invalid time string. Dangling unit or number.'
      );

      q.greaterThan('field', { $relativeTime: 'in N/A days' });
      expect((): ESObject => OfflineQuery.matchesQuery(q.className, obj, [], q)).assertThrowError(
        "bad $relativeTime (field) value. 'n/a' is not an integer."
      );
    });

    it('matches queries relation', 0, () => {
      const obj = new ParseObject('Item');
      const relation = obj.relation('author');
      const q = relation.query();
      expect(OfflineQuery.matchesQuery(q.className, obj, [], q)).assertEqual(false);
    });

    it('matches existence queries', 0, () => {
      const obj = new ParseObject('Item');
      obj.set('count', 100);
      const q = new ParseQuery('Item');
      q.exists('count');
      expect(OfflineQuery.matchesQuery(q.className, obj, [], q)).assertEqual(true);
      q.exists('name');
      expect(OfflineQuery.matchesQuery(q.className, obj, [], q)).assertEqual(false);
    });

    it('matches queries with doesNotExist constraint', 0, () => {
      const obj = new ParseObject('Item');
      obj.set('count', 100);

      let q = new ParseQuery('Item');
      q.doesNotExist('name');
      expect(OfflineQuery.matchesQuery(q.className, obj, [], q)).assertEqual(true);

      q = new ParseQuery('Item');
      q.doesNotExist('count');
      expect(OfflineQuery.matchesQuery(q.className, obj, [], q)).assertEqual(false);
    });

    it('matches on equality queries', 0, () => {
      const day = new Date();
      const location: ESObject = new ParseGeoPoint({
        latitude: 37.484815,
        longitude: -122.148377,
      });
      const obj = new ParseObject('Person');
      obj.set('score', 12).set('name', 'Bill').set('birthday', day).set('lastLocation', location);

      let q = new ParseQuery('Person');
      q.equalTo('score', 12);
      expect(OfflineQuery.matchesQuery(q.className, obj, [], q)).assertEqual(true);

      q = new ParseQuery('Person');
      q.equalTo('name', 'Bill');
      expect(OfflineQuery.matchesQuery(q.className, obj, [], q)).assertEqual(true);
      q.equalTo('name', 'Jeff');
      expect(OfflineQuery.matchesQuery(q.className, obj, [], q)).assertEqual(false);

      q = new ParseQuery('Person');
      q.containedIn('name', ['Adam', 'Ben', 'Charles']);
      expect(OfflineQuery.matchesQuery(q.className, obj, [], q)).assertEqual(false);
      q.containedIn('name', ['Adam', 'Bill', 'Charles']);
      expect(OfflineQuery.matchesQuery(q.className, obj, [], q)).assertEqual(true);

      q = new ParseQuery('Person');
      q.notContainedIn('name', ['Adam', 'Bill', 'Charles']);
      expect(OfflineQuery.matchesQuery(q.className, obj, [], q)).assertEqual(false);
      q.notContainedIn('name', ['Adam', 'Ben', 'Charles']);
      expect(OfflineQuery.matchesQuery(q.className, obj, [], q)).assertEqual(true);

      q = new ParseQuery('Person');
      q.equalTo('birthday', day);
      expect(OfflineQuery.matchesQuery(q.className, obj, [], q)).assertEqual(true);
      q.equalTo('birthday', new Date(1990, 1));
      expect(OfflineQuery.matchesQuery(q.className, obj, [], q)).assertEqual(false);

      q = new ParseQuery('Person');
      q.equalTo('lastLocation', location);
      expect(OfflineQuery.matchesQuery(q.className, obj, [], q)).assertEqual(true);
      q.equalTo(
        'lastLocation',
        new ParseGeoPoint({
          latitude: 37.4848,
          longitude: -122.1483,
        })
      );
      expect(OfflineQuery.matchesQuery(q.className, obj, [], q)).assertEqual(false);

      q.equalTo(
        'lastLocation',
        new ParseGeoPoint({
          latitude: 37.484815,
          longitude: -122.148377,
        })
      );
      q.equalTo('score', 12);
      q.equalTo('name', 'Bill');
      q.equalTo('birthday', day);
      expect(OfflineQuery.matchesQuery(q.className, obj, [], q)).assertEqual(true);

      q.equalTo('name', 'bill');
      expect(OfflineQuery.matchesQuery(q.className, obj, [], q)).assertEqual(false);

      let img = new ParseObject('Image');
      img.set('tags', ['nofilter', 'latergram', 'tbt']);

      q = new ParseQuery('Image');
      q.equalTo('tags', 'selfie');
      expect(OfflineQuery.matchesQuery(q.className, img, [], q)).assertEqual(false);
      q.equalTo('tags', 'tbt');
      expect(OfflineQuery.matchesQuery(q.className, img, [], q)).assertEqual(true);

      const q2 = new ParseQuery('Image');
      q2.containsAll('tags', ['latergram', 'nofilter']);
      expect(OfflineQuery.matchesQuery(q.className, img, [], q2)).assertEqual(true);
      q2.containsAll('tags', ['latergram', 'selfie']);
      expect(OfflineQuery.matchesQuery(q.className, img, [], q2)).assertEqual(false);

      const u: ESObject = new ParseUser();
      u.id = 'U2';
      q = new ParseQuery('Image');
      q.equalTo('owner', u);

      img = new ParseObject('Image');
      img.set('owner', u);

      expect(OfflineQuery.matchesQuery(q.className, img, [], q)).assertEqual(true);

      let json = img.toJSON();
      json.owner.objectId = 'U3';
      expect(OfflineQuery.matchesQuery(json, q, undefined, undefined)).assertEqual(false);

      // pointers in arrays
      q = new ParseQuery('Image');
      q.equalTo('owners', u);

      img = new ParseObject('Image');
      img.set('owners', [u]);
      expect(OfflineQuery.matchesQuery(q.className, img, [], q)).assertEqual(true);

      json = img.toJSON();
      json.owners[0].objectId = 'U3';
      expect(OfflineQuery.matchesQuery(json, q, undefined, undefined)).assertEqual(false);

      const u3: ESObject = new ParseUser();
      u3.id = 'U3';
      img = new ParseObject('Image');
      img.set('owners', [u3]);
      expect(OfflineQuery.matchesQuery(q.className, img, [], q)).assertEqual(false);
    });

    it('matches on inequalities', 0, () => {
      const player = new ParseObject('Person');
      player
        .set('score', 12)
        .set('name', 'Bill')
        .set('birthday', new Date(1980, 2, 4));

      let q = new ParseQuery('Person');
      q.lessThan('score', 15);
      expect(OfflineQuery.matchesQuery(q.className, player, [], q)).assertEqual(true);
      q.lessThan('score', 10);
      expect(OfflineQuery.matchesQuery(q.className, player, [], q)).assertEqual(false);

      q = new ParseQuery('Person');
      q.lessThanOrEqualTo('score', 15);
      expect(OfflineQuery.matchesQuery(q.className, player, [], q)).assertEqual(true);
      q.lessThanOrEqualTo('score', 12);
      expect(OfflineQuery.matchesQuery(q.className, player, [], q)).assertEqual(true);
      q.lessThanOrEqualTo('score', 10);
      expect(OfflineQuery.matchesQuery(q.className, player, [], q)).assertEqual(false);

      q = new ParseQuery('Person');
      q.greaterThan('score', 15);
      expect(OfflineQuery.matchesQuery(q.className, player, [], q)).assertEqual(false);
      q.greaterThan('score', 10);
      expect(OfflineQuery.matchesQuery(q.className, player, [], q)).assertEqual(true);

      q = new ParseQuery('Person');
      q.greaterThanOrEqualTo('score', 15);
      expect(OfflineQuery.matchesQuery(q.className, player, [], q)).assertEqual(false);
      q.greaterThanOrEqualTo('score', 12);
      expect(OfflineQuery.matchesQuery(q.className, player, [], q)).assertEqual(true);
      q.greaterThanOrEqualTo('score', 10);
      expect(OfflineQuery.matchesQuery(q.className, player, [], q)).assertEqual(true);

      q = new ParseQuery('Person');
      q.notEqualTo('score', 12);
      expect(OfflineQuery.matchesQuery(q.className, player, [], q)).assertEqual(false);
      q.notEqualTo('score', 40);
      expect(OfflineQuery.matchesQuery(q.className, player, [], q)).assertEqual(true);
    });

    it('matches an $or query', 0, () => {
      const player = new ParseObject('Player');
      player.set('score', 12).set('name', 'Player 1');

      const q = new ParseQuery('Player');
      q.equalTo('name', 'Player 1');
      const q2 = new ParseQuery('Player');
      q2.equalTo('name', 'Player 2');
      const q3 = new ParseQuery('Player');
      q3.equalTo('name', 'Player 3');
      const orQuery1 = ParseQuery.or(q, q2);
      const orQuery2 = ParseQuery.or(q2, q3);
      expect(OfflineQuery.matchesQuery(q.className, player, [], q)).assertEqual(true);
      expect(OfflineQuery.matchesQuery(q.className, player, [], q2)).assertEqual(false);
      expect(OfflineQuery.matchesQuery(q.className, player, [], orQuery1)).assertEqual(true);
      expect(OfflineQuery.matchesQuery(q.className, player, [], orQuery2)).assertEqual(false);
    });

    it('matches an $and query', 0, () => {
      const player = new ParseObject('Player');
      player.set('score', 12).set('name', 'Player 1');

      const q = new ParseQuery('Player');
      q.equalTo('name', 'Player 1');
      const q2 = new ParseQuery('Player');
      q2.equalTo('score', 12);
      const q3 = new ParseQuery('Player');
      q3.equalTo('score', 100);
      const andQuery1 = ParseQuery.and(q, q2);
      const andQuery2 = ParseQuery.and(q, q3);
      expect(OfflineQuery.matchesQuery(q.className, player, [], q)).assertEqual(true);
      expect(OfflineQuery.matchesQuery(q.className, player, [], q2)).assertEqual(true);
      expect(OfflineQuery.matchesQuery(q.className, player, [], andQuery1)).assertEqual(true);
      expect(OfflineQuery.matchesQuery(q.className, player, [], andQuery2)).assertEqual(false);
    });

    it('matches an $nor query', 0, () => {
      const player = new ParseObject('Player');
      player.set('score', 12).set('name', 'Player 1');

      const q = new ParseQuery('Player');
      q.equalTo('name', 'Player 1');
      const q2 = new ParseQuery('Player');
      q2.equalTo('name', 'Player 2');
      const q3 = new ParseQuery('Player');
      q3.equalTo('name', 'Player 3');

      const norQuery1 = ParseQuery.nor(q, q2);
      const norQuery2 = ParseQuery.nor(q2, q3);
      expect(OfflineQuery.matchesQuery(q.className, player, [], q)).assertEqual(true);
      expect(OfflineQuery.matchesQuery(q.className, player, [], q2)).assertEqual(false);
      expect(OfflineQuery.matchesQuery(q.className, player, [], q3)).assertEqual(false);
      expect(OfflineQuery.matchesQuery(q.className, player, [], norQuery1)).assertEqual(false);
      expect(OfflineQuery.matchesQuery(q.className, player, [], norQuery2)).assertEqual(true);
    });

    it('matches $regex queries', 0, () => {
      const player = new ParseObject('Player');
      player.set('score', 12).set('name', 'Player 1');

      let q = new ParseQuery('Player');
      q.startsWith('name', 'Play');
      expect(OfflineQuery.matchesQuery(q.className, player, [], q)).assertEqual(true);
      q.startsWith('name', 'Ploy');
      expect(OfflineQuery.matchesQuery(q.className, player, [], q)).assertEqual(false);

      q = new ParseQuery('Player');
      q.endsWith('name', ' 1');
      expect(OfflineQuery.matchesQuery(q.className, player, [], q)).assertEqual(true);
      q.endsWith('name', ' 2');
      expect(OfflineQuery.matchesQuery(q.className, player, [], q)).assertEqual(false);

      // Check that special characters are escaped
      player.set('name', 'Android-7');
      q = new ParseQuery('Player');
      q.contains('name', 'd-7');
      expect(OfflineQuery.matchesQuery(q.className, player, [], q)).assertEqual(true);

      q = new ParseQuery('Player');
      q.matches('name', /A.d/, 'm');
      expect(OfflineQuery.matchesQuery(q.className, player, [], q)).assertEqual(true);

      q.matches('name', /A[^n]d/);
      expect(OfflineQuery.matchesQuery(q.className, player, [], q)).assertEqual(false);

      // Check that the string \\E is returned to normal
      player.set('name', 'Slash \\E');
      q = new ParseQuery('Player');
      q.endsWith('name', 'h \\E');
      expect(OfflineQuery.matchesQuery(q.className, player, [], q)).assertEqual(true);

      q.endsWith('name', 'h \\Ee');
      expect(OfflineQuery.matchesQuery(q.className, player, [], q)).assertEqual(false);

      player.set('name', 'Slash \\Q and more');
      q = new ParseQuery('Player');
      q.contains('name', 'h \\Q and');
      expect(OfflineQuery.matchesQuery(q.className, player, [], q)).assertEqual(true);
      q.contains('name', 'h \\Q or');
      expect(OfflineQuery.matchesQuery(q.className, player, [], q)).assertEqual(false);

      q = new ParseQuery('Player');
      q._addCondition('status', '$regex', {
        test: () => {
          return true;
        },
      });
      expect(OfflineQuery.matchesQuery(q.className, player, [], q)).assertEqual(true);
    });

    it('matches $nearSphere queries', 0, () => {
      let q = new ParseQuery('Checkin');
      q.near('location', new ParseGeoPoint(20, 20));
      // With no max distance, any GeoPoint is 'near'
      const pt = new ParseObject('Checkin');
      pt.set('location', new ParseGeoPoint(40, 40));

      const ptUndefined = new ParseObject('Checkin');

      const ptNull = new ParseObject('Checkin');
      ptNull.set('location', null);

      expect(OfflineQuery.matchesQuery(q.className, pt, [], q)).assertEqual(true);
      expect(OfflineQuery.matchesQuery(q.className, ptUndefined, [], q)).assertEqual(false);
      expect(OfflineQuery.matchesQuery(q.className, ptNull, [], q)).assertEqual(false);

      q = new ParseQuery('Checkin');
      pt.set('location', new ParseGeoPoint(40, 40));

      q.withinRadians('location', new ParseGeoPoint(30, 30), 0.3);
      expect(OfflineQuery.matchesQuery(q.className, pt, [], q)).assertEqual(true);

      q.withinRadians('location', new ParseGeoPoint(30, 30), 0.2);
      expect(OfflineQuery.matchesQuery(q.className, pt, [], q)).assertEqual(false);

      q = new ParseQuery('Checkin');
      q._addCondition('location', '$maxDistance', 100);
      expect(OfflineQuery.matchesQuery(q.className, pt, [], q)).assertEqual(true);
    });

    it('matches $centerSphere queries', 0, () => {
      const pt = new ParseObject('Checkin');
      pt.set('location', new ParseGeoPoint(40, 40));

      const q = new ParseQuery('Checkin');
      q.withinRadians('location', new ParseGeoPoint(30, 30), 0.3, false);
      expect(OfflineQuery.matchesQuery(q.className, pt, [], q)).assertEqual(true);
    });

    it('matches $within queries', 0, () => {
      const caltrainStation = new ParseObject('Checkin');
      caltrainStation
        .set('name', 'Caltrain')
        .set('location', new ParseGeoPoint(37.776346, -122.394218));

      const santaClara = new ParseObject('Checkin');
      santaClara
        .set('name', 'Santa Clara')
        .set('location', new ParseGeoPoint(37.325635, -121.945753));

      const noLocation = new ParseObject('Checkin');
      noLocation.set('name', 'Santa Clara');

      const nullLocation = new ParseObject('Checkin');
      nullLocation.set('name', 'Santa Clara').set('location', null);

      let q = new ParseQuery('Checkin').withinGeoBox(
        'location',
        new ParseGeoPoint(37.708813, -122.526398),
        new ParseGeoPoint(37.822802, -122.373962)
      );

      expect(OfflineQuery.matchesQuery(q.className, caltrainStation, [], q)).assertEqual(true);
      expect(OfflineQuery.matchesQuery(q.className, santaClara, [], q)).assertEqual(false);
      expect(OfflineQuery.matchesQuery(q.className, noLocation, [], q)).assertEqual(false);
      expect(OfflineQuery.matchesQuery(q.className, nullLocation, [], q)).assertEqual(false);
      // Invalid rectangles
      q = new ParseQuery('Checkin').withinGeoBox(
        'location',
        new ParseGeoPoint(37.822802, -122.373962),
        new ParseGeoPoint(37.708813, -122.526398)
      );

      expect(OfflineQuery.matchesQuery(q.className, caltrainStation, [], q)).assertEqual(false);
      expect(OfflineQuery.matchesQuery(q.className, santaClara, [], q)).assertEqual(false);

      q = new ParseQuery('Checkin').withinGeoBox(
        'location',
        new ParseGeoPoint(37.708813, -122.373962),
        new ParseGeoPoint(37.822802, -122.526398)
      );

      expect(OfflineQuery.matchesQuery(q.className, caltrainStation, [], q)).assertEqual(false);
      expect(OfflineQuery.matchesQuery(q.className, santaClara, [], q)).assertEqual(false);
    });

    it('matches on subobjects with dot notation', 0, () => {
      const message = new ParseObject('Message');
      message.set('test', 'content').set('status', { x: 'read', y: 'delivered' });

      let q = new ParseQuery('Message');
      q.equalTo('status.x', 'read');
      expect(OfflineQuery.matchesQuery(q.className, message, [], q)).assertEqual(true);

      q = new ParseQuery('Message');
      q.equalTo('status.z', 'read');
      expect(OfflineQuery.matchesQuery(q.className, message, [], q)).assertEqual(false);

      q = new ParseQuery('Message');
      q.equalTo('status.x', 'delivered');
      expect(OfflineQuery.matchesQuery(q.className, message, [], q)).assertEqual(false);

      q = new ParseQuery('Message');
      q.notEqualTo('status.x', 'read');
      expect(OfflineQuery.matchesQuery(q.className, message, [], q)).assertEqual(false);

      q = new ParseQuery('Message');
      q.notEqualTo('status.z', 'read');
      expect(OfflineQuery.matchesQuery(q.className, message, [], q)).assertEqual(true);

      q = new ParseQuery('Message');
      q.notEqualTo('status.x', 'delivered');
      expect(OfflineQuery.matchesQuery(q.className, message, [], q)).assertEqual(true);

      q = new ParseQuery('Message');
      q.exists('status.x');
      expect(OfflineQuery.matchesQuery(q.className, message, [], q)).assertEqual(true);

      q = new ParseQuery('Message');
      q.exists('status.z');
      expect(OfflineQuery.matchesQuery(q.className, message, [], q)).assertEqual(false);

      q = new ParseQuery('Message');
      q.exists('nonexistent.x');
      expect(OfflineQuery.matchesQuery(q.className, message, [], q)).assertEqual(false);

      q = new ParseQuery('Message');
      q.doesNotExist('status.x');
      expect(OfflineQuery.matchesQuery(q.className, message, [], q)).assertEqual(false);

      q = new ParseQuery('Message');
      q.doesNotExist('status.z');
      expect(OfflineQuery.matchesQuery(q.className, message, [], q)).assertEqual(true);

      q = new ParseQuery('Message');
      q.doesNotExist('nonexistent.z');
      expect(OfflineQuery.matchesQuery(q.className, message, [], q)).assertEqual(true);

      q = new ParseQuery('Message');
      q.equalTo('status.x', 'read');
      q.doesNotExist('status.y');
      expect(OfflineQuery.matchesQuery(q.className, message, [], q)).assertEqual(false);

      q = new ParseQuery('Message');
      q._addCondition('status', '$exists', 'invalid');
      expect(OfflineQuery.matchesQuery(q.className, message, [], q)).assertEqual(true);
    });

    it('should support containedIn with pointers', 0, () => {
      const profile = new ParseObject('Profile');
      profile.id = 'abc';
      const message = new ParseObject('Message');
      message.set('profile', profile);

      let q = new ParseQuery('Message');
      q.containedIn('profile', [
        ParseObject.fromJSON({ className: 'Profile', objectId: 'abc' }),
        ParseObject.fromJSON({ className: 'Profile', objectId: 'def' }),
      ]);
      expect(OfflineQuery.matchesQuery(q.className, message, [], q)).assertEqual(true);

      q = new ParseQuery('Message');
      q.containedIn('profile', [
        ParseObject.fromJSON({ className: 'Profile', objectId: 'ghi' }),
        ParseObject.fromJSON({ className: 'Profile', objectId: 'def' }),
      ]);
      expect(OfflineQuery.matchesQuery(q.className, message, [], q)).assertEqual(false);
    });

    it('should support containedIn with array of pointers', 0, () => {
      const profile1 = new ParseObject('Profile');
      profile1.id = 'yeahaw';
      const profile2 = new ParseObject('Profile');
      profile2.id = 'yes';

      const message = new ParseObject('Message');
      message.id = 'O2';
      message.set('profiles', [profile1, profile2]);

      let q = new ParseQuery('Message');
      q.containedIn('profiles', [
        ParseObject.fromJSON({ className: 'Profile', objectId: 'no' }),
        ParseObject.fromJSON({ className: 'Profile', objectId: 'yes' }),
      ]);

      expect(OfflineQuery.matchesQuery(q.className, message, [], q)).assertEqual(true);

      q = new ParseQuery('Message');
      q.containedIn('profiles', [
        ParseObject.fromJSON({ className: 'Profile', objectId: 'no' }),
        ParseObject.fromJSON({ className: 'Profile', objectId: 'nope' }),
      ]);

      expect(OfflineQuery.matchesQuery(q.className, message, [], q)).assertEqual(false);
    });

    it('should support notContainedIn with pointers', 0, () => {
      const profile = new ParseObject('Profile');
      profile.id = 'abc';
      let message = new ParseObject('Message');
      message.id = 'O1';
      message.set('profile', profile);

      let q = new ParseQuery('Message');
      q.notContainedIn('profile', [
        ParseObject.fromJSON({ className: 'Profile', objectId: 'def' }),
        ParseObject.fromJSON({ className: 'Profile', objectId: 'ghi' }),
      ]);
      expect(OfflineQuery.matchesQuery(q.className, message, [], q)).assertEqual(true);

      profile.id = 'def';
      message = new ParseObject('Message');
      message.set('profile', profile);
      q = new ParseQuery('Message');
      q.notContainedIn('profile', [
        ParseObject.fromJSON({ className: 'Profile', objectId: 'ghi' }),
        ParseObject.fromJSON({ className: 'Profile', objectId: 'def' }),
      ]);
      expect(OfflineQuery.matchesQuery(q.className, message, [], q)).assertEqual(false);
    });

    it('should support containedIn queries with [objectId]', 0, () => {
      const profile = new ParseObject('Profile');
      profile.id = 'abc';
      let message = new ParseObject('Message');
      message.set('profile', profile);

      let q = new ParseQuery('Message');
      q.containedIn('profile', ['abc', 'def']);
      expect(OfflineQuery.matchesQuery(q.className, message, [], q)).assertEqual(true);

      profile.id = 'ghi';
      message = new ParseObject('Message');
      message.set('profile', profile);

      q = new ParseQuery('Message');
      q.containedIn('profile', ['abc', 'def']);
      expect(OfflineQuery.matchesQuery(q.className, message, [], q)).assertEqual(false);
    });

    it('should support notContainedIn queries with [objectId]', 0, () => {
      const profile = new ParseObject('Profile');
      profile.id = 'ghi';
      const message = new ParseObject('Message');
      message.set('profile', profile);

      let q = new ParseQuery('Message');
      q.notContainedIn('profile', ['abc', 'def']);
      expect(OfflineQuery.matchesQuery(q.className, message, [], q)).assertEqual(true);

      q = new ParseQuery('Message');
      q.notContainedIn('profile', ['abc', 'def', 'ghi']);
      expect(OfflineQuery.matchesQuery(q.className, message, [], q)).assertEqual(false);
    });

    it('should support matchesKeyInQuery', 0, () => {
      const restaurant = new ParseObject('Restaurant');
      restaurant.set('ratings', 5);
      restaurant.set('location', 'Earth');
      const person1 = new ParseObject('Person');
      person1.set('hometown', 'Earth');
      const person2 = new ParseObject('Person');
      person2.set('hometown', 'Mars');

      let query = new ParseQuery('Restaurant');
      query.greaterThan('rating', 4);
      let mainQuery = new ParseQuery('Person');

      mainQuery.matchesKeyInQuery('hometown', 'location', query);
      expect(
        OfflineQuery.matchesQuery(mainQuery.className, person1, [person1, person2, restaurant], mainQuery)
      ).assertEqual(true);
      expect(
        OfflineQuery.matchesQuery(mainQuery.className, person2, [person1, person2, restaurant], mainQuery)
      ).assertEqual(false);
      expect(OfflineQuery.matchesQuery(mainQuery.className, person1, [], mainQuery)).assertEqual(false);

      query = new ParseQuery('Restaurant');
      query.greaterThan('rating', 4);
      mainQuery = new ParseQuery('Person');

      mainQuery.doesNotMatchKeyInQuery('hometown', 'location', query);
      expect(
        OfflineQuery.matchesQuery(
          mainQuery.className,
          person1,
          [person1, person2, restaurant._toFullJSON()],
          mainQuery
        )
      ).assertEqual(false);
      expect(
        OfflineQuery.matchesQuery(mainQuery.className, person2, [person1, person2, restaurant], mainQuery)
      ).assertEqual(true);
      expect(OfflineQuery.matchesQuery(mainQuery.className, person1, [], mainQuery)).assertEqual(false);
    });

    it('should support OfflineQuery.matchesQuery', 0, () => {
      const parentObjects: ParseObject[] = [];
      const childObjects: ParseObject[] = [];
      for (let i = 0; i < 10; i += 1) {
        const child = new ParseObject('ChildObject');
        child.id = 100 + i + "";
        child.set('x', i);
        const parent = new ParseObject('ParentObject');
        parent.id = 10 + i + "";
        parent.set('child', child);
        childObjects.push(child);
        parentObjects.push(parent);
      }
      let subQuery = new ParseQuery('ChildObject');
      subQuery.greaterThan('x', 5);
      let q = new ParseQuery('ParentObject');
      q.matchesQuery('child', subQuery);
      expect(
        OfflineQuery.matchesQuery(q.className, parentObjects[0], [...parentObjects, ...childObjects], q)
      ).assertEqual(false);
      expect(
        OfflineQuery.matchesQuery(q.className, parentObjects[9], [...parentObjects, ...childObjects], q)
      ).assertEqual(true);
      expect(OfflineQuery.matchesQuery(q.className, parentObjects[0], [], q)).assertEqual(false);

      subQuery = new ParseQuery('ChildObject');
      subQuery.greaterThan('x', 5);
      q = new ParseQuery('ParentObject');
      q.doesNotMatchQuery('child', subQuery);
      expect(
        OfflineQuery.matchesQuery(q.className, parentObjects[0], [...parentObjects, ...childObjects], q)
      ).assertEqual(true);
      expect(
        OfflineQuery.matchesQuery(q.className, parentObjects[9], [...parentObjects, ...childObjects], q)
      ).assertEqual(false);
      expect(OfflineQuery.matchesQuery(q.className, parentObjects[0], [], q)).assertEqual(true);
    });

    it('should support containedBy query', 0, () => {
      const obj1 = new ParseObject('Numbers');
      const obj2 = new ParseObject('Numbers');
      const obj3 = new ParseObject('Numbers');
      obj1.set('numbers', [0, 1, 2]);
      obj2.set('numbers', [2, 0]);
      obj3.set('numbers', [1, 2, 3, 4]);

      const q = new ParseQuery('Numbers');
      q.containedBy('numbers', [1, 2, 3, 4, 5]);
      expect(OfflineQuery.matchesQuery(q.className, obj1, [], q)).assertEqual(false);
      expect(OfflineQuery.matchesQuery(q.className, obj2, [], q)).assertEqual(false);
      expect(OfflineQuery.matchesQuery(q.className, obj3, [], q)).assertEqual(true);
    });

    it('should support withinPolygon query', 0, () => {
      const sacramento = new ParseObject('Location');
      sacramento.set('location', new ParseGeoPoint(38.52, -121.5));
      sacramento.set('name', 'Sacramento');

      const honolulu = new ParseObject('Location');
      honolulu.set('location', new ParseGeoPoint(21.35, -157.93));
      honolulu.set('name', 'Honolulu');

      const sf = new ParseObject('Location');
      sf.set('location', new ParseGeoPoint(37.75, -122.68));
      sf.set('name', 'San Francisco');

      const points: ESObject[] = [
        new ParseGeoPoint(37.85, -122.33),
        new ParseGeoPoint(37.85, -122.9),
        new ParseGeoPoint(37.68, -122.9),
        new ParseGeoPoint(37.68, -122.33),
      ];
      const q = new ParseQuery('Location');
      q.withinPolygon('location', points);

      expect(OfflineQuery.matchesQuery(q.className, sacramento, [], q)).assertEqual(false);
      expect(OfflineQuery.matchesQuery(q.className, honolulu, [], q)).assertEqual(false);
      expect(OfflineQuery.matchesQuery(q.className, sf, [], q)).assertEqual(true);
    });

    it('should support polygonContains query', 0, () => {
      const p1: ESObject[] = [
        [0, 0],
        [0, 1],
        [1, 1],
        [1, 0],
      ];
      const p2: ESObject[] = [
        [0, 0],
        [0, 2],
        [2, 2],
        [2, 0],
      ];
      const p3: ESObject[] = [
        [10, 10],
        [10, 15],
        [15, 15],
        [15, 10],
        [10, 10],
      ];

      const polygon1: ESObject = new ParsePolygon(p1);
      const polygon2: ESObject = new ParsePolygon(p2);
      const polygon3: ESObject = new ParsePolygon(p3);
      const obj1 = new ParseObject('Bounds');
      const obj2 = new ParseObject('Bounds');
      const obj3 = new ParseObject('Bounds');
      obj1.set('polygon', polygon1);
      obj2.set('polygon', polygon2);
      obj3.set('polygon', polygon3);

      const point = new ParseGeoPoint(0.5, 0.5);
      const q = new ParseQuery('Bounds');
      q.polygonContains('polygon', point);

      expect(OfflineQuery.matchesQuery(q.className, obj1, [], q)).assertEqual(true);
      expect(OfflineQuery.matchesQuery(q.className, obj2, [], q)).assertEqual(true);
      expect(OfflineQuery.matchesQuery(q.className, obj3, [], q)).assertEqual(false);
    });

    it('should not support invalid $geoWithin query', 0, () => {
      const sacramento = new ParseObject('Location');
      sacramento.set('location', new ParseGeoPoint(38.52, -121.5));
      sacramento.set('name', 'Sacramento');

      const honolulu = new ParseObject('Location');
      honolulu.set('location', new ParseGeoPoint(21.35, -157.93));
      honolulu.set('name', 'Honolulu');

      const sf = new ParseObject('Location');
      sf.set('location', new ParseGeoPoint(37.75, -122.68));
      sf.set('name', 'San Francisco');

      const points = [
        new ParseGeoPoint(37.85, -122.33),
        new ParseGeoPoint(37.85, -122.9),
        new ParseGeoPoint(37.68, -122.9),
        new ParseGeoPoint(37.68, -122.33),
      ];
      const q = new ParseQuery('Location');
      q._addCondition('location', '$geoWithin', { $unknown: points });

      expect(OfflineQuery.matchesQuery(q.className, sacramento, [], q)).assertEqual(false);
      expect(OfflineQuery.matchesQuery(q.className, honolulu, [], q)).assertEqual(false);
      expect(OfflineQuery.matchesQuery(q.className, sf, [], q)).assertEqual(false);
    });

    it('should validate query', 0, () => {
      let query = new ParseQuery('TestObject');
      query.equalTo('foo', 'bar');
      try {
        OfflineQuery.validateQuery(query);
        OfflineQuery.validateQuery(query.toJSON());

        query.matches('myString', 'football', 'm');
        OfflineQuery.validateQuery(query);

        expect(true).assertEqual(true);
      } catch (_) {
        // Should not reach here
        expect(false).assertEqual(true);
      }

      query = new ParseQuery('TestObject');
      query.matches('myString', 'football', 'some invalid thing');
      try {
        OfflineQuery.validateQuery(query);
        expect(true).assertEqual(false);
      } catch (e) {
        expect(e.code).assertEqual(ParseError.INVALID_QUERY);
      }

      query = new ParseQuery('TestObject');
      query.equalTo('$foo', 'bar');
      try {
        OfflineQuery.validateQuery(query);
        expect(true).assertEqual(false);
      } catch (e) {
        expect(e.code).assertEqual(ParseError.INVALID_KEY_NAME);
      }
    });
  })
}