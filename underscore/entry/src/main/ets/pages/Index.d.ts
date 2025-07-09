import { Callback } from "@kit.BasicServicesKit";
import { ecnyPaymentService } from "@kit.PaymentKit";

declare module 'underscore' {
  export function first(obj: Array<any>): string;
  export function last(obj: Array<any>): string;
  export function union(obj1: Array<any>, obj2: Array<any>, obj3: Array<any>): string;
  export function indexOf(arr: Array<any>, index: number): string;
  export function range(number): string;
  export function chain(number): underscore;
  export function each(obj: Array<any>, iterate: Callback<any>): string;
  export function map(obj: Array<any>, iterate: Callback<any>): string;
  export function reduce(obj: Array<any>, iterate: any, memo: number): string;
  export function filter(obj: Array<any>, iterate: Callback<any>): string;
  export function invoke(obj: Array<Array<any>>, path: string): string;

  export function keys(obj: any): any;
  export function values(obj: any): any;
  export function pairs(obj: any): any;
  export function extend(obj1: any, obj2: any): any;
  export function clone(obj: any): any;
  export function random(min: number, max: number): string;
  export function escape(escape: string): string;
  export function now(): string;

  export class underscore{
    sortBy(obj: any): underscore;
    map(obj: any): underscore;
    first();
    value();
  }
}