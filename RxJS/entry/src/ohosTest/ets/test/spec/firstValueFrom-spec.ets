import { from, firstValueFrom, EMPTY, EmptyError, throwError, of, Observable } from 'rxjs';
import { finalize, take } from 'rxjs/operators';
import { describe, expect } from '../hypium';
import { it } from '../It'

export default function firstValueFromTest() {
  describe('firstValueFrom', () => {
    it('should emit the first value as a promise', async () => {
      let finalized = false;
      const source = from([0, 1, 2, 3, 4, 5]).pipe(finalize(() => (finalized = true)));
      const result = await firstValueFrom(source);
      expect(finalized).assertTrue();
      expect(result).assertEqual(0);

    });

    it('should support a default value', async () => {
      const source = EMPTY;
      const result = await firstValueFrom(source, {
        defaultValue: 0
      });
      expect(result).assertEqual(0);
    });

    it('should support an undefined config', async () => {
      const source = EMPTY;
      let error: any = null;
      try {
        await firstValueFrom(source, undefined as any);
      } catch (err) {
        error = err;
      }
      expect(error instanceof EmptyError).assertTrue();
    });

    it('should error for empty observables', async () => {
      const source = EMPTY;
      let error: any = null;
      try {
        await firstValueFrom(source);
      } catch (err) {
        error = err;
      }
      expect(error instanceof EmptyError).assertTrue();
    });

    it('should error for errored observables', async () => {
      const source = throwError(() => new Error('blorp!'));
      let error: any = null;
      try {
        await firstValueFrom(source);
      } catch (err) {
        error = err;
      }
      expect(error).assertInstanceOf('Error');
      expect(error.message).assertEqual('blorp!');
    });

    it('should work with a synchronous observable', async () => {
      let finalized = false;
      const source = of('apples', 'bananas').pipe(finalize(() => (finalized = true)));
      const result = await firstValueFrom(source);
      expect(result).assertEqual('apples');
      expect(finalized).assertTrue();
    });

    it('should stop listening to a synchronous observable when resolved', async () => {
      const sideEffects: number[] = [];
      const synchronousObservable = new Observable<number>(subscriber => {
        // This will check to see if the subscriber was closed on each loop
        // when the unsubscribe hits (from the `take`), it should be closed
        for (let i = 0;!subscriber.closed && i < 10; i++) {
          sideEffects.push(i);
          subscriber.next(i);
        }
      });
      const result = await firstValueFrom(synchronousObservable);
      expect(sideEffects.length).assertEqual(1);
      expect(sideEffects[0]).assertEqual(0);
    });
  });
}