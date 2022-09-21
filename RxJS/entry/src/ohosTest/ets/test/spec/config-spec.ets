/** @prettier */
import { config } from 'rxjs';
import { expect, describe, it, afterEach } from '../hypium';
import { Observable } from 'rxjs';
import { timeoutProvider } from 'rxjs/internal/scheduler/timeoutProvider';

export default function configTest() {
  describe('config', () => {
    it('should have a Promise property that defaults to nothing', 0, () => {
      expect(config.Promise).assertUndefined();
    });
  });

  describe('onUnhandledError', () => {
    afterEach(() => {
      config.onUnhandledError = null;
    });

    it('should default to null', 0, () => {
      expect(config.onUnhandledError).assertNull();
    });

    it('should call asynchronously if an error is emitted and not handled by the consumer observer', 0, () => {
      let called = false;
      const results: any[] = [];

      config.onUnhandledError = (err) => {
        called = true;
        expect(err).assertEqual('bad');
      };

      const source = new Observable<number>((subscriber) => {
        subscriber.next(1);
        subscriber.error('bad');
      });

      source.subscribe({
        next: (value) => results.push(value),
      });
      expect(called).assertFalse();
      expect(results.length).assertEqual(1);
      expect(results[0]).assertEqual(1);
    });

    it('should call asynchronously if an error is emitted and not handled by the consumer next callback', 0, () => {
      let called = false;
      const results: any[] = [];

      config.onUnhandledError = (err) => {
        called = true;
        expect(err).assertEqual('bad');

      };

      const source = new Observable<number>((subscriber) => {
        subscriber.next(1);
        subscriber.error('bad');
      });

      source.subscribe((value) => results.push(value));
      expect(called).assertFalse();
      expect(results.length).assertEqual(1);
      expect(results[0]).assertEqual(1);
    });

    it('should call asynchronously if an error is emitted and not handled by the consumer in the empty case', 0, () => {
      let called = false;
      config.onUnhandledError = (err) => {
        called = true;
        expect(err).assertEqual('bad');

      };

      const source = new Observable((subscriber) => {
        subscriber.error('bad');
      });

      source.subscribe();
      expect(called).assertFalse();
    });

    /**
     * This test is added so people know this behavior is _intentional_. It's part of the contract of observables
     * and, while I'm not sure I like it, it might start surfacing untold numbers of errors, and break
     * node applications if we suddenly changed this to start throwing errors on other jobs for instances
     * where users accidentally called `subscriber.error` twice. Likewise, would we report an error
     * for two calls of `complete`? This is really something a build-time tool like a linter should
     * capture. Not a run time error reporting event.
     */
    it('should not be called if two errors are sent to the subscriber', 0, () => {
      let called = false;
      config.onUnhandledError = () => {
        called = true;
      };

      const source = new Observable((subscriber) => {
        subscriber.error('handled');
        subscriber.error('swallowed');
      });

      let syncSentError: any;
      source.subscribe({
        error: (err) => {
          syncSentError = err;
        },
      });

      expect(syncSentError).assertEqual('handled');
      // When called, onUnhandledError is called on a timeout, so delay the
      // the assertion of the expectation until after the point at which
      // onUnhandledError would have been called.
      timeoutProvider.setTimeout(() => {
        expect(called).assertFalse();
      }, 0);
    });
  });

  describe('onStoppedNotification', () => {
    afterEach(() => {
      config.onStoppedNotification = null;
    });

    it('should default to null', 0, () => {
      expect(config.onStoppedNotification).assertNull();
    });

    it('should be called asynchronously if a subscription setup errors after the subscription is closed by an error', 0, () => {
      let called = false;
      config.onStoppedNotification = (notification) => {
        called = true;
        expect(notification.kind).assertEqual('E');
        expect(notification['error']).assertEqual('bad');

      };

      const source = new Observable((subscriber) => {
        subscriber.error('handled');
        throw 'bad';
      });

      let syncSentError: any;
      source.subscribe({
        error: (err) => {
          syncSentError = err;
        },
      });

      expect(syncSentError).assertEqual('handled');
      expect(called).assertFalse();
    });

    it('should be called asynchronously if a subscription setup errors after the subscription is closed by a completion', 0, () => {
      let called = false;
      let completed = false;
      config.onStoppedNotification = (notification) => {
        called = true;
        expect(notification.kind).assertEqual('E');
        expect(notification['error']).assertEqual('bad');

      };

      const source = new Observable((subscriber) => {
        subscriber.complete();
        throw 'bad';
      });

      source.subscribe({
        error: () => {
          throw 'should not be called';
        },
        complete: () => {
          completed = true;
        },
      });

      expect(completed).assertTrue();
      expect(called).assertFalse();
    });

    it('should be called if a next is sent to the stopped subscriber', 0, () => {
      let called = false;
      config.onStoppedNotification = (notification) => {
        called = true;
        expect(notification.kind).assertEqual('N');
        expect(notification['value']).assertEqual(2);

      };

      const source = new Observable((subscriber) => {
        subscriber.next(1);
        subscriber.complete();
        subscriber.next(2);
      });

      let syncSentValue: any;
      source.subscribe({
        next: (value) => {
          syncSentValue = value;
        },
      });

      expect(syncSentValue).assertEqual(1);
      expect(called).assertFalse();
    });

    it('should be called if two errors are sent to the subscriber', 0, () => {
      let called = false;
      config.onStoppedNotification = (notification) => {
        called = true;
        expect(notification.kind).assertEqual('E');
        expect(notification['error']).assertEqual('swallowed');


      };

      const source = new Observable((subscriber) => {
        subscriber.error('handled');
        subscriber.error('swallowed');
      });

      let syncSentError: any;
      source.subscribe({
        error: (err) => {
          syncSentError = err;
        },
      });

      expect(syncSentError).assertEqual('handled');
      expect(called).assertFalse();
    });

    it('should be called if two completes are sent to the subscriber', 0, () => {
      let called = false;
      config.onStoppedNotification = (notification) => {
        called = true;
        expect(notification.kind).assertEqual('C');

      };

      const source = new Observable((subscriber) => {
        subscriber.complete();
        subscriber.complete();
      });

      source.subscribe();

      expect(called).assertFalse();
    });
  });

}