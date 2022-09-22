import { describe,expect,it} from '@ohos/hypium';
import { Observable, of, Subscriber } from 'rxjs';
import { observable as symbolObservable } from 'rxjs/internal/symbol/observable';
import { asInteropObservable, asInteropSubscriber } from './interop-helper';

describe('interop helper', () => {
  it('should simulate interop observables', 0,() => {
    const observable: any = asInteropObservable(of(42));
    expect(observable).assertInstanceOf('Observable');
    expect(observable[symbolObservable]).assertInstanceOf('function');
  });

  it('should simulate interop subscribers', 0,() => {
    const subscriber: any = asInteropSubscriber(new Subscriber());
    expect(subscriber).assertInstanceOf('Subscriber');
  });
});