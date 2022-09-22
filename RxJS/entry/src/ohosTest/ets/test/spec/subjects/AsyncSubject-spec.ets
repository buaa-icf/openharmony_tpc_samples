import { describe, expect } from '../../hypium';
import { it } from '../../It'
import { AsyncSubject, Observer } from 'rxjs';
import lodash from 'lodash'


class TestObserver implements Observer<number> {
  results: (number | string)[] = [];

  next(value: number): void {
    this.results.push(value);
  }

  error(err: any): void {
    this.results.push(err);
  }

  complete(): void {
    this.results.push('done');
  }
}

export default function asyncSubjectTest(){
/** @test {AsyncSubject} */
describe('AsyncSubject', () => {
  it('should emit the last value when complete', () => {
    const subject = new AsyncSubject<number>();
    const observer = new TestObserver();
    subject.subscribe(observer);

    subject.next(1);
    expect(lodash.isEqual(observer.results, [])).assertTrue();
    subject.next(2);
    expect(lodash.isEqual(observer.results, [])).assertTrue();
    subject.complete();
    expect(lodash.isEqual(observer.results, [2, 'done'])).assertTrue();
  });

  it('should emit the last value when subscribing after complete', () => {
    const subject = new AsyncSubject<number>();
    const observer = new TestObserver();

    subject.next(1);
    subject.next(2);
    subject.complete();

    subject.subscribe(observer);
    expect(lodash.isEqual(observer.results, [2, 'done'])).assertTrue();
  });

  it('should keep emitting the last value to subsequent subscriptions', () => {
    const subject = new AsyncSubject<number>();
    const observer = new TestObserver();
    const subscription = subject.subscribe(observer);

    subject.next(1);
    expect(lodash.isEqual(observer.results, [])).assertTrue();
    subject.next(2);
    expect(lodash.isEqual(observer.results, [])).assertTrue();
    subject.complete();
    expect(lodash.isEqual(observer.results, [2, 'done'])).assertTrue();

    subscription.unsubscribe();

    observer.results = [];
    subject.subscribe(observer);
    expect(lodash.isEqual(observer.results, [2, 'done'])).assertTrue();
  });

  it('should not emit values after complete', () => {
    const subject = new AsyncSubject<number>();
    const observer = new TestObserver();

    subject.subscribe(observer);

    subject.next(1);
    expect(lodash.isEqual(observer.results, [])).assertTrue();
    subject.next(2);
    expect(lodash.isEqual(observer.results, [])).assertTrue();
    subject.complete();
    subject.next(3);
    expect(lodash.isEqual(observer.results, [2, 'done'])).assertTrue();
  });

  it('should not allow change value after complete', () => {
    const subject = new AsyncSubject<number>();
    const observer = new TestObserver();
    const otherObserver = new TestObserver();
    subject.subscribe(observer);

    subject.next(1);
    expect(lodash.isEqual(observer.results, [])).assertTrue();
    subject.complete();
    expect(lodash.isEqual(observer.results, [1, 'done'])).assertTrue();
    subject.next(2);
    subject.subscribe(otherObserver);
    expect(lodash.isEqual(otherObserver.results, [1, 'done'])).assertTrue();
  });

  it('should not emit values if unsubscribed before complete', () => {
    const subject = new AsyncSubject<number>();
    const observer = new TestObserver();
    const subscription = subject.subscribe(observer);

    subject.next(1);
    expect(lodash.isEqual(observer.results, [])).assertTrue();
    subject.next(2);
    expect(lodash.isEqual(observer.results, [])).assertTrue();

    subscription.unsubscribe();

    subject.next(3);
    expect(lodash.isEqual(observer.results, [])).assertTrue();
    subject.complete();
    expect(lodash.isEqual(observer.results, [])).assertTrue();
  });

  it('should just complete if no value has been nexted into it', () => {
    const subject = new AsyncSubject<number>();
    const observer = new TestObserver();
    subject.subscribe(observer);

    expect(lodash.isEqual(observer.results, [])).assertTrue();
    subject.complete();
    expect(lodash.isEqual(observer.results, ['done'])).assertTrue();
  });

  it('should keep emitting complete to subsequent subscriptions', () => {
    const subject = new AsyncSubject<number>();
    const observer = new TestObserver();
    const subscription = subject.subscribe(observer);

    expect(lodash.isEqual(observer.results, [])).assertTrue();
    subject.complete();
    expect(lodash.isEqual(observer.results, ['done'])).assertTrue();

    subscription.unsubscribe();
    observer.results = [];

    subject.error(new Error(''));

    subject.subscribe(observer);
    expect(lodash.isEqual(observer.results, ['done'])).assertTrue();
  });

  it('should only error if an error is passed into it', () => {
    const expected = new Error('bad');
    const subject = new AsyncSubject<number>();
    const observer = new TestObserver();
    subject.subscribe(observer);

    subject.next(1);
    expect(lodash.isEqual(observer.results, [])).assertTrue();

    subject.error(expected);
    expect(lodash.isEqual(observer.results, [expected])).assertTrue();
  });

  it('should keep emitting error to subsequent subscriptions', () => {
    const expected = new Error('bad');
    const subject = new AsyncSubject<number>();
    const observer = new TestObserver();
    const subscription = subject.subscribe(observer);

    subject.next(1);
    expect(lodash.isEqual(observer.results, [])).assertTrue();

    subject.error(expected);
    expect(lodash.isEqual(observer.results, [expected])).assertTrue();

    subscription.unsubscribe();

    observer.results = [];
    subject.subscribe(observer);
    expect(lodash.isEqual(observer.results, [expected])).assertTrue();
  });

  it('should not allow send complete after error', () => {
    const expected = new Error('bad');
    const subject = new AsyncSubject<number>();
    const observer = new TestObserver();
    const subscription = subject.subscribe(observer);

    subject.next(1);
    expect(lodash.isEqual(observer.results, [])).assertTrue();

    subject.error(expected);
    expect(lodash.isEqual(observer.results, [expected])).assertTrue();

    subscription.unsubscribe();

    observer.results = [];

    subject.complete();
    subject.subscribe(observer);
    expect(lodash.isEqual(observer.results, [expected])).assertTrue();
  });

  it('should not be reentrant via complete', () => {
    const subject = new AsyncSubject<number>();
    let calls = 0;
    subject.subscribe({
      next: (value) => {
        calls++;
        if (calls < 2) {
          // if this is more than 1, we're reentrant, and that's bad.
          subject.complete();
        }
      },
    });

    subject.next(1);
    subject.complete();

    expect(calls).assertEqual(1);
  });

  it('should not be reentrant via next', () => {
    const subject = new AsyncSubject<number>();
    let calls = 0;
    subject.subscribe({
      next: (value) => {
        calls++;
        if (calls < 2) {
          // if this is more than 1, we're reentrant, and that's bad.
          subject.next(value + 1);
        }
      },
    });

    subject.next(1);
    subject.complete();

    expect(calls).assertEqual(1);
  });

  it('should allow reentrant subscriptions', () => {
    const subject = new AsyncSubject<number>();
    let results: any[] = [];

    subject.subscribe({
      next: (value) => {
        subject.subscribe({
          next: (value) => results.push('inner: ' + (value + value)),
          complete: () => results.push('inner: done'),
        });
        results.push('outer: ' + value);
      },
      complete: () => results.push('outer: done'),
    });

    subject.next(1);
    expect(lodash.isEqual(results, [])).assertTrue();
    subject.complete();
    expect(lodash.isEqual(results, ['inner: 2', 'inner: done', 'outer: 1', 'outer: done'])).assertTrue();
  });
});
}