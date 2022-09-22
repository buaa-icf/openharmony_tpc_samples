import { expect, describe, beforeEach, afterEach } from '../hypium';
import { it } from '../It'
import { SafeSubscriber } from 'rxjs/internal/Subscriber';
import { Subscriber, Observable, config, of, Observer } from 'rxjs';
import { asInteropSubscriber } from './helpers/interop-helper';
import { getRegisteredFinalizers } from './helpers/subscription';
import lodash from 'lodash'
/** @test {Subscriber} */
export default function subscriberTest(){
describe('SafeSubscriber', () => {
  it('should ignore next messages after unsubscription', () => {
    let times = 0;

    const sub = new SafeSubscriber({
      next() {
        times += 1;
      }
    });

    sub.next();
    sub.next();
    sub.unsubscribe();
    sub.next();

    expect(times).assertEqual(2);
  });

  it('should ignore error messages after unsubscription', () => {
    let times = 0;
    let errorCalled = false;

    const sub = new SafeSubscriber({
      next() {
        times += 1;
      },
      error() {
        errorCalled = true;
      }
    });

    sub.next();
    sub.next();
    sub.unsubscribe();
    sub.next();
    sub.error();

    expect(times).assertEqual(2);
    expect(errorCalled).assertFalse();
  });

  it('should ignore complete messages after unsubscription', () => {
    let times = 0;
    let completeCalled = false;

    const sub = new SafeSubscriber({
      next() {
        times += 1;
      },
      complete() {
        completeCalled = true;
      }
    });

    sub.next();
    sub.next();
    sub.unsubscribe();
    sub.next();
    sub.complete();

    expect(times).assertEqual(2);
    expect(completeCalled).assertFalse();
  });

  it('should not be closed when other subscriber with same observer instance completes', () => {
    const observer = {
      next: function () { /*noop*/
      }
    };

    const sub1 = new SafeSubscriber(observer);
    const sub2 = new SafeSubscriber(observer);

    sub2.complete();

    expect(sub1.closed).assertFalse();
    expect(sub2.closed).assertTrue();
  });

  it('should call complete observer without any arguments', () => {
    let argument: Array<any> | null = null;

    const observer = {
      complete: (...args: Array<any>) => {
        argument = args;
      }
    };

    const sub1 = new SafeSubscriber(observer);
    sub1.complete();

    expect(argument.length).assertEqual(0);
  });

  it('should chain interop unsubscriptions', () => {
    let observableUnsubscribed = false;
    let subscriberUnsubscribed = false;
    let subscriptionUnsubscribed = false;

    const subscriber = new SafeSubscriber<void>();
    subscriber.add(() => subscriberUnsubscribed = true);

    const source = new Observable<void>(() => () => observableUnsubscribed = true);
    const subscription = source.subscribe(asInteropSubscriber(subscriber));
    subscription.add(() => subscriptionUnsubscribed = true);
    subscriber.unsubscribe();

    expect(observableUnsubscribed).assertTrue();
    expect(subscriberUnsubscribed).assertTrue();
    expect(subscriptionUnsubscribed).assertTrue();
  });

  it('should have idempotent unsubscription', () => {
    let count = 0;
    const subscriber = new SafeSubscriber();
    subscriber.add(() => ++count);
    expect(count).assertEqual(0);

    subscriber.unsubscribe();
    expect(count).assertEqual(1);

    subscriber.unsubscribe();
    expect(count).assertEqual(1);
  });

  it('should close, unsubscribe, and unregister all finalizers after complete', () => {
    let isUnsubscribed = false;
    const subscriber = new SafeSubscriber();
    subscriber.add(() => isUnsubscribed = true);
    subscriber.complete();
    expect(isUnsubscribed).assertTrue();
    expect(subscriber.closed).assertTrue();
    expect(getRegisteredFinalizers(subscriber).length).assertEqual(0);
  });

  it('should close, unsubscribe, and unregister all finalizers after error', () => {
    let isTornDown = false;
    const subscriber = new SafeSubscriber({
      error: () => {
        // Mischief managed!
        // Adding this handler here to prevent the call to error from
        // throwing, since it will have an error handler now.
      }
    });
    subscriber.add(() => isTornDown = true);
    subscriber.error(new Error('test'));
    expect(isTornDown).assertTrue();
    expect(subscriber.closed).assertTrue();
    expect(getRegisteredFinalizers(subscriber).length).assertEqual(0);
  });
});

  it('should finalize and unregister all finalizers after complete', () => {
    let isTornDown = false;
    const subscriber = new Subscriber();
    subscriber.add(() => {
      isTornDown = true
    });
    subscriber.complete();
    expect(isTornDown).assertTrue();
    expect(getRegisteredFinalizers(subscriber).length).assertEqual(0);
  });

  it('should NOT break this context on next methods from unfortunate consumers', () => {
    // This is a contrived class to illustrate that we can pass another
    // object that is "observer shaped" and not have it lose its context
    // as it would have in v5 - v6.
    class CustomConsumer {
      valuesProcessed: string[] = [];

      // In here, we access instance state and alter it.
      next(value: string) {
        if (value === 'reset') {
          this.valuesProcessed = [];
        } else {
          this.valuesProcessed.push(value);
        }
      }
    };

    const consumer = new CustomConsumer();

    of('old', 'old', 'reset', 'new', 'new').subscribe(consumer);

    expect(lodash.isEqual(consumer.valuesProcessed, ['new', 'new'])).assertFalse();
  });
}