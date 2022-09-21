import { expect, describe, beforeEach, afterEach } from '../hypium';
import {
  Subject,
  ObjectUnsubscribedError,
  Observable,
  AsyncSubject,
  Observer,
  of,
  config,
  throwError,
  concat
} from 'rxjs';
import { AnonymousSubject } from 'rxjs/internal/Subject';
import { catchError, delay, map, mergeMap } from 'rxjs/operators';
import { TestScheduler } from 'rxjs/testing';
import { observableMatcher } from './helpers/observableMatcher';
import { it } from '../It'
import lodash from 'lodash'


export default function subjectTest(){
/** @test {Subject} */
describe('Subject', () => {
  let rxTestScheduler: TestScheduler;

  beforeEach(() => {
    rxTestScheduler = new TestScheduler(observableMatcher);
  });

  it('should allow next with undefined or any when created with no type', (done) => {
    const subject = new Subject();
    subject.subscribe(
      { next: (x) => {
        expect(x).assertUndefined();
      }, complete: done }
    );

    const data: any = undefined;
    subject.next(undefined);
    subject.next(data);
    subject.complete();
  });

  it('should allow empty next when created with void type', (done) => {
    const subject = new Subject<void>();
    subject.subscribe(
      { next: (x) => {
        expect(x).assertUndefined();
      }, complete: done }
    );

    subject.next();
    subject.complete();
  });

  it('should pump values right on through itself', (done) => {
    const subject = new Subject<string>();
    const expected = ['foo', 'bar'];

    subject.subscribe(
      { next: (x: string) => {
        expect(x).assertEqual(expected.shift());
      }, complete: done }
    );

    subject.next('foo');
    subject.next('bar');
    subject.complete();
  });

  it('should pump values to multiple subscribers', (done) => {
    const subject = new Subject<string>();
    const expected = ['foo', 'bar'];

    let i = 0;
    let j = 0;

    subject.subscribe(function (x) {
      expect(x).assertEqual(expected[i++]);
    });

    subject.subscribe(
      { next: function (x) {
        expect(x).assertEqual(expected[j++]);
      }, complete: done }
    );

    expect(subject.observers.length).assertEqual(2);
    subject.next('foo');
    subject.next('bar');
    subject.complete();
  });

  it('should handle subscribers that arrive and leave at different times, ' + 'subject does not complete', () => {
    const subject = new Subject<number>();
    const results1: (number | string)[] = [];
    const results2: (number | string)[] = [];
    const results3: (number | string)[] = [];

    subject.next(1);
    subject.next(2);
    subject.next(3);
    subject.next(4);

    const subscription1 = subject.subscribe(
      { next: function (x) {
        results1.push(x);
      }, error: function (e) {
        results1.push('E');
      }, complete: () => {
        results1.push('C');
      } }
    );

    subject.next(5);

    const subscription2 = subject.subscribe(
      { next: function (x) {
        results2.push(x);
      }, error: function (e) {
        results2.push('E');
      }, complete: () => {
        results2.push('C');
      } }
    );

    subject.next(6);
    subject.next(7);

    subscription1.unsubscribe();

    subject.next(8);

    subscription2.unsubscribe();

    subject.next(9);
    subject.next(10);

    const subscription3 = subject.subscribe(
      { next: function (x) {
        results3.push(x);
      }, error: function (e) {
        results3.push('E');
      }, complete: () => {
        results3.push('C');
      } }
    );

    subject.next(11);

    subscription3.unsubscribe();

    expect(lodash.isEqual(results1, [5, 6, 7])).assertTrue();
    expect(lodash.isEqual(results2, [6, 7, 8])).assertTrue();
    expect(lodash.isEqual(results3, [11])).assertTrue();
  });

  it('should handle subscribers that arrive and leave at different times, ' + 'subject completes', () => {
    const subject = new Subject<number>();
    const results1: (number | string)[] = [];
    const results2: (number | string)[] = [];
    const results3: (number | string)[] = [];

    subject.next(1);
    subject.next(2);
    subject.next(3);
    subject.next(4);

    const subscription1 = subject.subscribe(
      { next: function (x) {
        results1.push(x);
      }, error: function (e) {
        results1.push('E');
      }, complete: () => {
        results1.push('C');
      } }
    );

    subject.next(5);

    const subscription2 = subject.subscribe(
      { next: function (x) {
        results2.push(x);
      }, error: function (e) {
        results2.push('E');
      }, complete: () => {
        results2.push('C');
      } }
    );

    subject.next(6);
    subject.next(7);

    subscription1.unsubscribe();

    subject.complete();

    subscription2.unsubscribe();

    const subscription3 = subject.subscribe(
      { next: function (x) {
        results3.push(x);
      }, error: function (e) {
        results3.push('E');
      }, complete: () => {
        results3.push('C');
      } }
    );

    subscription3.unsubscribe();

    expect(lodash.isEqual(results1, [5, 6, 7])).assertTrue();
    expect(lodash.isEqual(results2, [6, 7, 'C'])).assertTrue();
    expect(lodash.isEqual(results3, ['C'])).assertTrue();
  });

  it('should handle subscribers that arrive and leave at different times, ' + 'subject terminates with an error', () => {
    const subject = new Subject<number>();
    const results1: (number | string)[] = [];
    const results2: (number | string)[] = [];
    const results3: (number | string)[] = [];

    subject.next(1);
    subject.next(2);
    subject.next(3);
    subject.next(4);

    const subscription1 = subject.subscribe(
      { next: function (x) {
        results1.push(x);
      }, error: function (e) {
        results1.push('E');
      }, complete: () => {
        results1.push('C');
      } }
    );

    subject.next(5);

    const subscription2 = subject.subscribe(
      { next: function (x) {
        results2.push(x);
      }, error: function (e) {
        results2.push('E');
      }, complete: () => {
        results2.push('C');
      } }
    );

    subject.next(6);
    subject.next(7);

    subscription1.unsubscribe();

    subject.error(new Error('err'));

    subscription2.unsubscribe();

    const subscription3 = subject.subscribe(
      { next: function (x) {
        results3.push(x);
      }, error: function (e) {
        results3.push('E');
      }, complete: () => {
        results3.push('C');
      } }
    );

    subscription3.unsubscribe();

    expect(lodash.isEqual(results1, [5, 6, 7])).assertTrue();
    expect(lodash.isEqual(results2, [6, 7, 'E'])).assertTrue();
    expect(lodash.isEqual(results3, ['E'])).assertTrue();
  });

  it('should handle subscribers that arrive and leave at different times, ' + 'subject completes before nexting any value', () => {
    const subject = new Subject<number>();
    const results1: (number | string)[] = [];
    const results2: (number | string)[] = [];
    const results3: (number | string)[] = [];

    const subscription1 = subject.subscribe(
      { next: function (x) {
        results1.push(x);
      }, error: function (e) {
        results1.push('E');
      }, complete: () => {
        results1.push('C');
      } }
    );

    const subscription2 = subject.subscribe(
      { next: function (x) {
        results2.push(x);
      }, error: function (e) {
        results2.push('E');
      }, complete: () => {
        results2.push('C');
      } }
    );

    subscription1.unsubscribe();

    subject.complete();

    subscription2.unsubscribe();

    const subscription3 = subject.subscribe(
      { next: function (x) {
        results3.push(x);
      }, error: function (e) {
        results3.push('E');
      }, complete: () => {
        results3.push('C');
      } }
    );

    subscription3.unsubscribe();

    expect(lodash.isEqual(results1, [])).assertTrue();
    expect(lodash.isEqual(results2, ['C'])).assertTrue();
    expect(lodash.isEqual(results3, ['C'])).assertTrue();
  });

  it('should disallow new subscriber once subject has been disposed', () => {
    const subject = new Subject<number>();
    const results1: (number | string)[] = [];
    const results2: (number | string)[] = [];
    const results3: (number | string)[] = [];

    const subscription1 = subject.subscribe(
      { next: function (x) {
        results1.push(x);
      }, error: function (e) {
        results1.push('E');
      }, complete: () => {
        results1.push('C');
      } }
    );

    subject.next(1);
    subject.next(2);

    const subscription2 = subject.subscribe(
      { next: function (x) {
        results2.push(x);
      }, error: function (e) {
        results2.push('E');
      }, complete: () => {
        results2.push('C');
      } }
    );

    subject.next(3);
    subject.next(4);
    subject.next(5);

    subscription1.unsubscribe();
    subscription2.unsubscribe();
    subject.unsubscribe();

    let error = null;
    try {
      subject.subscribe(
        { next: function (x) {
          results3.push(x);
        }, error: function (err) {
        } }
      );
    } catch (err) {
      error = err;
    }
    expect(error != null && error instanceof ObjectUnsubscribedError).assertTrue();

    expect(lodash.isEqual(results1, [1, 2, 3, 4, 5])).assertTrue();
    expect(lodash.isEqual(results2, [3, 4, 5])).assertTrue();
    expect(results3.length == 0).assertTrue();
  });

  it('should not allow values to be nexted after it is unsubscribed', (done) => {
    const subject = new Subject<string>();
    const expected = ['foo'];
    let err = null;

    subject.subscribe(function (x) {
      expect(x).assertEqual(expected.shift());
    });

    subject.next('foo');
    subject.unsubscribe();
    try {
      subject.next('bar')
    } catch (e) {
      err = e;
    }
    expect(err != null && err instanceof ObjectUnsubscribedError).assertTrue();
    done();
  });

  it('should clean out unsubscribed subscribers', (done) => {
    const subject = new Subject();

    const sub1 = subject.subscribe(function (x) {
      //noop
    });

    const sub2 = subject.subscribe(function (x) {
      //noop
    });

    expect(subject.observers.length).assertEqual(2);
    sub1.unsubscribe();
    expect(subject.observers.length).assertEqual(1);
    sub2.unsubscribe();
    expect(subject.observers.length).assertEqual(0);
    done();
  });

  it('should expose observed status', () => {
    const subject = new Subject();

    expect(subject.observed).assertEqual(false);

    const sub1 = subject.subscribe(function (x) {
      //noop
    });

    expect(subject.observed).assertEqual(true);

    const sub2 = subject.subscribe(function (x) {
      //noop
    });

    expect(subject.observed).assertTrue();
    sub1.unsubscribe();
    expect(subject.observed).assertTrue();
    sub2.unsubscribe();
    expect(subject.observed).assertFalse();
    subject.unsubscribe();
    expect(subject.observed).assertFalse();
  });

  it('should have a static create function that works', () => {
    expect(Subject.create instanceof Function).assertTrue();
    const source = of(1, 2, 3, 4, 5);
    const nexts: number[] = [];
    const output: number[] = [];

    let error: any;
    let complete = false;
    let outputComplete = false;

    const destination = {
      closed: false,
      next: function (x: number) {
        nexts.push(x);
      },
      error: function (err: any) {
        error = err;
        this.closed = true;
      },
      complete: function () {
        complete = true;
        this.closed = true;
      },
    };

    const sub: Subject<any> = Subject.create(destination, source);

    sub.subscribe({
      next: function (x: number) {
        output.push(x);
      },
      complete: () => {
        outputComplete = true;
      }
    });

    sub.next('a');
    sub.next('b');
    sub.next('c');
    sub.complete();

    expect(lodash.isEqual(nexts, ['a', 'b', 'c'])).assertTrue();
    expect(complete).assertTrue();
    expect(error).assertUndefined();

    expect(lodash.isEqual(output, [1, 2, 3, 4, 5])).assertTrue();
    expect(outputComplete).assertTrue();
  });

  it('should have a static create function that works also to raise errors', () => {
    expect(Subject.create instanceof Function).assertTrue();
    const source = of(1, 2, 3, 4, 5);
    const nexts: number[] = [];
    const output: number[] = [];

    let error: any;
    let complete = false;
    let outputComplete = false;

    const destination = {
      closed: false,
      next: function (x: number) {
        nexts.push(x);
      },
      error: function (err: any) {
        error = err;
        this.closed = true;
      },
      complete: function () {
        complete = true;
        this.closed = true;
      },
    };

    const sub: Subject<any> = Subject.create(destination, source);

    sub.subscribe({
      next: function (x: number) {
        output.push(x);
      },
      complete: () => {
        outputComplete = true;
      }
    });

    sub.next('a');
    sub.next('b');
    sub.next('c');
    sub.error('boom');

    expect(lodash.isEqual(nexts, ['a', 'b', 'c'])).assertTrue();
    expect(complete).assertFalse();
    expect(error).assertEqual('boom');

    expect(lodash.isEqual(output, [1, 2, 3, 4, 5])).assertTrue();
    expect(outputComplete).assertTrue();
  });

  it('should be an Observer which can be given to Observable.subscribe', (done) => {
    const source = of(1, 2, 3, 4, 5);
    const subject = new Subject<number>();
    const expected = [1, 2, 3, 4, 5];

    subject.subscribe(
      { next: function (x) {
        expect(x).assertEqual(expected.shift());
      }, error: (x) => {
        done(new Error('should not be called'));
      }, complete: () => {
        done();
      } }
    );

    source.subscribe(subject);
  });

  it('should be usable as an Observer of a finite delayed Observable', (done) => {
    const source = of(1, 2, 3).pipe(delay(50));
    const subject = new Subject<number>();

    const expected = [1, 2, 3];

    subject.subscribe(
      { next: function (x) {
        expect(x).assertEqual(expected.shift());
      }, error: (x) => {
        done(new Error('should not be called'));
      }, complete: () => {
        done();
      } }
    );

    source.subscribe(subject);
  });

  it('should throw ObjectUnsubscribedError when emit after unsubscribed', () => {
    const subject = new Subject<string>();
    subject.unsubscribe();
    let err1 = null;
    let err2 = null;
    let err3 = null;
    try {
      subject.next('a');
    } catch (e) {
      err1 = e;
    }
    expect(err1 != null && err1 instanceof ObjectUnsubscribedError).assertTrue();

    try {
      subject.error('a');
    } catch (e) {
      err2 = e;
    }
    expect(err2 != null && err2 instanceof ObjectUnsubscribedError).assertTrue();
    try {
      subject.complete();
    } catch (e) {
      err3 = e;
    }
    expect(err3 != null && err3 instanceof ObjectUnsubscribedError).assertTrue();
  });

  it('should not next after completed', () => {
    const subject = new Subject<string>();
    const results: string[] = [];
    subject.subscribe(
      { next: (x) => results.push(x), complete: () => results.push('C') }
    );
    subject.next('a');
    subject.complete();
    subject.next('b');
    expect(lodash.isEqual(results, ['a', 'C'])).assertTrue();
  });

  it('should not next after error', () => {
    const error = new Error('wut?');
    const subject = new Subject<string>();
    const results: string[] = [];
    subject.subscribe(
      { next: (x) => results.push(x), error: (err) => results.push(err) }
    );
    subject.next('a');
    subject.error(error);
    subject.next('b');
    expect(lodash.isEqual(results, ['a', error])).assertTrue();
  });


    it('should hide subject', () => {
      const subject = new Subject();
      const observable = subject.asObservable();

      expect(lodash.isEqual(subject, observable)).assertFalse();

      expect(observable instanceof Observable).assertTrue();
      expect(observable instanceof Subject).assertFalse();
    });

    it('should handle subject never emits', () => {
      rxTestScheduler.run(({ hot, expectObservable }) => {
        const observable = hot('-').asObservable();

        expectObservable(observable).toBe('-');
      });
    });

    it('should handle subject completes without emits', () => {
      rxTestScheduler.run(({ hot, expectObservable }) => {
        const observable = hot('--^--|').asObservable();
        const expected = '        ---|';

        expectObservable(observable).toBe(expected);
      });
    });

    it('should handle subject throws', () => {
      rxTestScheduler.run(({ hot, expectObservable }) => {
        const observable = hot('--^--#').asObservable();
        const expected = '        ---#';

        expectObservable(observable).toBe(expected);
      });
    });

    it('should handle subject emits', () => {
      rxTestScheduler.run(({ hot, expectObservable }) => {
        const observable = hot('--^--x--|').asObservable();
        const expected = '        ---x--|';

        expectObservable(observable).toBe(expected);
      });
    });

    it('should work with inherited subject', () => {
      const results: (number | string)[] = [];
      const subject = new AsyncSubject<number>();

      subject.next(42);
      subject.complete();

      const observable = subject.asObservable();

      observable.subscribe(
        { next: (x) => results.push(x), complete: () => results.push('done') }
      );

      expect(lodash.isEqual(results, [42, 'done'])).assertTrue();
    });
  });

  describe('error thrown scenario', () => {
    afterEach(() => {
      config.onUnhandledError = null;
    });

    it('should not synchronously error when nexted into', (done) => {
      config.onUnhandledError = (err) => {
        expect(err.message).assertEqual('Boom!');
        done();
      };

      const source = new Subject<number>();
      source.subscribe();
      source.subscribe(() => {
        throw new Error('Boom!');
      });
      source.subscribe();
      try {
        source.next(42);
      } catch (err) {
        // This should not happen!
        expect(true).assertFalse();
      }
      expect(true).assertTrue();
    });
  });


  it('should be exposed', () => {
    expect(AnonymousSubject instanceof Function).assertTrue();
  });

  it('should not be eager', () => {
    let subscribed = false;

    const subject = Subject.create(
      null,
      new Observable((observer: Observer<any>) => {
        subscribed = true;
        const subscription = of('x').subscribe(observer);
        return () => {
          subscription.unsubscribe();
        };
      })
    );

    const observable = subject.asObservable();
    expect(subscribed).assertFalse();

    observable.subscribe();
    expect(subscribed).assertTrue();
  });

describe('useDeprecatedSynchronousErrorHandling', () => {
  beforeEach(() => {
    config.useDeprecatedSynchronousErrorHandling = true;
  });

  afterEach(() => {
    config.useDeprecatedSynchronousErrorHandling = false;
  });

  it('should throw an error when nexting with a flattened, erroring inner observable', () => {
    const subject = new Subject<string>();
    subject.pipe(mergeMap(() => throwError(() => new Error('bad')))).subscribe();

    expect(() => {
      subject.next('wee');
    }).assertThrowError('bad');
  });

  it('should throw an error when nexting with a flattened, erroring inner observable with more than one operator', () => {
    const subject = new Subject<string>();
    subject.pipe(mergeMap(() => throwError(() => new Error('bad'))), map(x => x)).subscribe();

    expect(() => {
      subject.next('wee');
    }).assertThrowError('bad');
  });

  it('should throw an error when notifying an error with catchError returning an erroring inner observable', () => {
    const subject = new Subject<string>();
    subject.pipe(catchError(() => throwError(() => new Error('bad')))).subscribe();

    expect(() => {
      subject.error('wee');
    }).assertThrowError('bad');
  });

  it('should throw an error when nexting with an operator that errors synchronously', () => {
    const subject = new Subject<string>();
    subject.pipe(mergeMap(() => {
      throw new Error('lol');
    })).subscribe();

    expect(() => {
      subject.next('wee');
    }).assertThrowError('lol');
  });


  it('should throw an error when notifying an error with a catchError that errors synchronously', () => {
    const subject = new Subject<string>();
    subject.pipe(catchError(() => {
      throw new Error('lol');
    })).subscribe();

    expect(() => {
      subject.error('wee');
    }).assertThrowError('lol');
  });

  it('should throw an error when nexting with an erroring next handler', () => {
    const subject = new Subject<string>();
    subject.subscribe(() => {
      throw new Error('lol');
    });

    expect(() => {
      subject.next('wee');
    }).assertThrowError('lol');
  });

  it('should throw an error when notifying with an erroring error handler', () => {
    const subject = new Subject<string>();
    subject.subscribe({
      error: () => {
        throw new Error('lol');
      }
    });

    expect(() => {
      subject.error('wee');
    }).assertThrowError('lol');
  });

  it('should throw an error when notifying with an erroring complete handler', () => {
    const subject = new Subject<string>();
    subject.subscribe({
      complete: () => {
        throw new Error('lol');
      }
    });

    expect(() => {
      subject.complete();
    }).assertThrowError('lol');
  });

  it('should throw an error when notifying an complete, and concatenated with another observable that synchronously errors', () => {
    const subject = new Subject<string>();
    concat(subject, throwError(new Error('lol'))).subscribe();

    expect(() => {
      subject.complete();
    }).assertThrowError('lol');
  });

  it('should not throw on second error passed', () => {
    const subject = new Subject();

    subject.subscribe();

    expect(() => {
      subject.error(new Error('one'));
    }).assertThrowError('one');

  });

  it('should not throw on second error passed, even after having been operated on', () => {
    const subject = new Subject();

    subject.pipe(mergeMap(x => [x])).subscribe();

    expect(() => {
      subject.error(new Error('one'));
    }).assertThrowError('one');
  });

  it('deep rethrowing 1', () => {
    const subject1 = new Subject();
    const subject2 = new Subject();

    subject2.subscribe();

    subject1.subscribe({
      next: () => subject2.error(new Error('hahaha'))
    });

    expect(() => {
      subject1.next('test');
    }).assertThrowError('hahaha');
  });

  it('deep rethrowing 2', () => {
    const subject1 = new Subject();

    subject1.subscribe({
      next: () => {
        throwError(new Error('hahaha')).subscribe();
      }
    });

    expect(() => {
      subject1.next('test');
    }).assertThrowError('hahaha');
  });
});
}