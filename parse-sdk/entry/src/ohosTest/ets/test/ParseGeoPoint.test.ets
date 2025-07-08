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
import { ParseGeoPoint } from "@ohos/parser-sdk";

export default function parseGeoPointTest() {
  describe('GeoPoint', () => {
    it('can be constructed from various inputs', 0, () => {
      let point = new ParseGeoPoint();
      expect(point.latitude).assertEqual(0);
      expect(point.longitude).assertEqual(0);

      point = new ParseGeoPoint(42, 36);
      expect(point.latitude).assertEqual(42);
      expect(point.longitude).assertEqual(36);

      point = new ParseGeoPoint([12, 24]);
      expect(point.latitude).assertEqual(12);
      expect(point.longitude).assertEqual(24);

      point = new ParseGeoPoint({ latitude: 8, longitude: 88 });
      expect(point.latitude).assertEqual(8);
      expect(point.longitude).assertEqual(88);
    });

    it('throws when created with non numbers values', 0, () => {
      [
        [NaN, NaN],
        [false, true],
        ['29', '10'],
        [29, '10'],
        ['29', 10],
        [['29', '10']],
        [{ latitude: '29', longitude: '10' } as ESObject],
      ].forEach((case_test: ESObject) => {
        expect(() => {
          new ParseGeoPoint(case_test);
        }).assertThrowError('GeoPoint latitude and longitude must be valid numbers');
      });
    });

    it('can set latitude and longitude', 0, () => {
      const point = new ParseGeoPoint();
      expect(point.latitude).assertEqual(0);
      expect(point.longitude).assertEqual(0);

      point.latitude = 5.5;
      expect(point.latitude).assertEqual(5.5);

      point.latitude = 10;
      expect(point.latitude).assertEqual(10);

      point.longitude = 12.1;
      expect(point.longitude).assertEqual(12.1);

      point.longitude = 14.9;
      expect(point.longitude).assertEqual(14.9);
    });

    it('throws for points out of bounds', 0, () => {
      expect(() => {
        new ParseGeoPoint(90.01, 0.0);
      }).assertThrowError('');

      expect(() => {
        new ParseGeoPoint(-90.01, 0.0);
      }).assertThrowError('');

      expect(() => {
        new ParseGeoPoint(0.0, 180.01);
      }).assertThrowError('');

      expect(() => {
        new ParseGeoPoint(0.0, -180.01);
      }).assertThrowError('');
    });

    it('can calculate distance in radians', 0, () => {
      const d2r = Math.PI / 180.0;
      const pointA = new ParseGeoPoint();
      const pointB = new ParseGeoPoint();

      // Zero
      expect(pointA.radiansTo(pointB)).assertEqual(0);
      expect(pointB.radiansTo(pointA)).assertEqual(0);

      // Wrap Long
      pointA.longitude = 179.0;
      pointB.longitude = -179.0;
      expect(pointA.radiansTo(pointB).toFixed(5)).assertEqual((2 * d2r).toFixed(5));
      expect(pointB.radiansTo(pointA).toFixed(5)).assertEqual((2 * d2r).toFixed(5));

      // North South Lat
      pointA.latitude = 89.0;
      pointA.longitude = 0.0;
      pointB.latitude = -89.0;
      pointB.longitude = 0.0;
      expect(pointA.radiansTo(pointB).toFixed(5)).assertEqual((178 * d2r).toFixed(5));
      expect(pointB.radiansTo(pointA).toFixed(5)).assertEqual((178 * d2r).toFixed(5));

      // Long wrap Lat
      pointA.latitude = 89.0;
      pointA.longitude = 0.0;
      pointB.latitude = -89.0;
      pointB.longitude = 179.9999;
      expect(pointA.radiansTo(pointB).toFixed(5)).assertEqual((180 * d2r).toFixed(5));
      expect(pointB.radiansTo(pointA).toFixed(5)).assertEqual((180 * d2r).toFixed(5));

      pointA.latitude = 79.0;
      pointA.longitude = 90.0;
      pointB.latitude = -79.0;
      pointB.longitude = -90;
      expect(pointA.radiansTo(pointB).toFixed(5)).assertEqual((180 * d2r).toFixed(5));
      expect(pointB.radiansTo(pointA).toFixed(5)).assertEqual((180 * d2r).toFixed(5));

      // Wrap near pole - somewhat ill conditioned case due to pole proximity
      pointA.latitude = 85.0;
      pointA.longitude = 90.0;
      pointB.latitude = 85.0;
      pointB.longitude = -90;
      expect(pointA.radiansTo(pointB).toFixed(5)).assertEqual((10 * d2r).toFixed(5));
      expect(pointB.radiansTo(pointA).toFixed(5)).assertEqual((10 * d2r).toFixed(5));

      // Reference cities
      // Sydney Australia
      pointA.latitude = -34.0;
      pointA.longitude = 151.0;
      // Buenos Aires
      pointB.latitude = -34.5;
      pointB.longitude = -58.35;
      expect(pointA.radiansTo(pointB).toFixed(2)).assertEqual(1.85.toString());
      expect(pointB.radiansTo(pointA).toFixed(2)).assertEqual(1.85.toString());
    });

    it('can calculate distances in mi and km', 0, () => {
      // [SAC]  38.52  -121.50  Sacramento,CA
      const sacramento = new ParseGeoPoint(38.52, -121.5);

      // [HNL]  21.35  -157.93  Honolulu Int,HI
      const honolulu = new ParseGeoPoint(21.35, -157.93);

      // [51Q]  37.75  -122.68  San Francisco,CA
      const sanfran = new ParseGeoPoint(37.75, -122.68);

      // Vorkuta 67.509619,64.085999
      const vorkuta = new ParseGeoPoint(67.509619, 64.085999);

      // London
      const london = new ParseGeoPoint(51.501904, -0.115356);

      // Northampton
      const northampton = new ParseGeoPoint(52.241256, -0.895386);

      // Powell St BART station
      const powell = new ParseGeoPoint(37.785071, -122.407007);

      // Apple store
      const astore = new ParseGeoPoint(37.785809, -122.406363);

      // Self
      expect(honolulu.kilometersTo(honolulu).toFixed(3)).assertEqual(0.0.toFixed(3));
      expect(honolulu.milesTo(honolulu).toFixed(3)).assertEqual(0.0.toFixed(3));

      // Symmetric
      let epsilon = Math.pow(10, 2) / 2;
      expect(sacramento.kilometersTo(honolulu) >= 3964.8 - epsilon && sacramento.kilometersTo(honolulu) <= 3964.8 + epsilon).assertTrue()
      expect(honolulu.kilometersTo(sacramento) >= 3964.8 - epsilon && honolulu.kilometersTo(sacramento) <= 3964.8 + epsilon).assertTrue();
      epsilon = Math.pow(10, 1) / 2;
      expect(sacramento.milesTo(honolulu) >= 2463.6 - epsilon && sacramento.milesTo(honolulu) <= 2463.6 + epsilon).assertTrue();
      expect(honolulu.milesTo(sacramento) >= 2463.6 - epsilon && honolulu.milesTo(sacramento) <= 2463.6 + epsilon).assertTrue();

      // Semi-local
      expect(london.kilometersTo(northampton).toFixed(0)).assertEqual(98.4.toFixed(0));
      expect(london.milesTo(northampton).toFixed(0)).assertEqual(61.2.toFixed(0));

      epsilon = Math.pow(10, 0) / 2;
      expect(sacramento.kilometersTo(sanfran) - 134.5).assertLess(epsilon);
      epsilon = Math.pow(10, 1) / 2;
      expect(sacramento.milesTo(sanfran) - 84.8).assertLessOrEqual(epsilon);

      // Very local
      epsilon = Math.pow(10, -2) / 2;
      expect(powell.kilometersTo(astore) - 0.1).assertLessOrEqual(epsilon);

      // Far (for error tolerance's sake)
      epsilon = Math.pow(10, 3) / 2;
      expect(sacramento.kilometersTo(vorkuta) - 8303.8).assertLessOrEqual(epsilon);
      expect(sacramento.milesTo(vorkuta) - 5159.7).assertLessOrEqual(epsilon);
    });

    it('can test equality against another GeoPoint', 0, () => {
      let a = new ParseGeoPoint(40, 40);
      expect(a.equals(a)).assertTrue();

      let b = new ParseGeoPoint(40, 40);
      expect(a.equals(b)).assertTrue();
      expect(b.equals(a)).assertTrue();

      b = new ParseGeoPoint(50, 40);
      expect(a.equals(b)).assertFalse();
      expect(b.equals(a)).assertFalse();

      a = new ParseGeoPoint(40.001, 40.001);
      b = new ParseGeoPoint(40.001, 40.001);
      expect(a.equals(b)).assertTrue();
      expect(b.equals(a)).assertTrue();

      b = new ParseGeoPoint(40, 40);
      expect(a.equals(b)).assertFalse();
      expect(b.equals(a)).assertFalse();

      a = new ParseGeoPoint(40, 50);
      expect(a.equals(b)).assertFalse();
      expect(b.equals(a)).assertFalse();
    });

    // it('can get current location', 0, async () => {
    //   global.navigator.geolocation = {
    //     getCurrentPosition: (success, _, options) => {
    //       success({
    //         coords: {
    //           latitude: 10,
    //           longitude: 20,
    //         },
    //       });
    //       expect(options).toEqual({ timeout: 5000 });
    //     },
    //   };
    //   const geoPoint = await ParseGeoPoint.current({ timeout: 5000 });
    //   expect(geoPoint.latitude).toBe(10);
    //   expect(geoPoint.longitude).toBe(20);
    // });

    // it('can get current location error', async () => {
    //   global.navigator.geolocation = {
    //     getCurrentPosition: (_, error, options) => {
    //       error({
    //         message: 'PERMISSION_DENIED',
    //       });
    //       expect(options).toEqual({ timeout: 5000 });
    //     },
    //   };
    //   await expect(ParseGeoPoint.current({ timeout: 5000 })).rejects.toEqual({
    //     message: 'PERMISSION_DENIED',
    //   });
    // });
  });
}