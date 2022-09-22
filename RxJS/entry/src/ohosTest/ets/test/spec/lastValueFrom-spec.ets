import { from, lastValueFrom, EMPTY, EmptyError, throwError, of } from 'rxjs';
import { describe, expect } from '../hypium';
import { it } from '../It'
import { finalize, take } from 'rxjs/operators';

export default function lastValueFromTest(){
describe('lastValueFrom', () => {
  it('should emit the last value as a promise',async () => {
    let finalized = false;
    const source = from([1, 0, 2, 8, 6, 9]).pipe(
      finalize(() => (finalized = true))
    );
    const result = await lastValueFrom(source);
    expect(result).assertEqual(9);
    expect(finalized).assertTrue();
  });

  it('should support a default value', async () => {
    const source = EMPTY;
    const result = await lastValueFrom(source, { defaultValue: 0 });
    expect(result).assertEqual(0);
  });

  it('should support an undefined config', async () => {
    const source = EMPTY;
    let error: any = null;
    try {
      await lastValueFrom(source, undefined as any);
    } catch (err) {
      error = err;
    }
    expect(error instanceof EmptyError).assertTrue();
  });

  it('should error for empty observables', async () => {
    const source = EMPTY;
    let error: any = null;
    try {
      await lastValueFrom(source);
    } catch (err) {
      error = err;
    }
    expect(error instanceof EmptyError).assertTrue();
  });

  it('should error for errored observables', async () => {
    const source = throwError(() => new Error('blorp!'));
    let error: any = null;
    try {
      await lastValueFrom(source);
    } catch (err) {
      error = err;
    }
    expect(error).assertInstanceOf('Error');
    expect(error.message).assertEqual('blorp!');
  });

  it('should work with a synchronous observable',async () => {
    let finalized = false;
    const source = of('apples', 'bananas').pipe(finalize(() => (finalized = true)));
    const result = await lastValueFrom(source);
    expect(result).assertEqual('bananas');
    expect(finalized).assertTrue();
  });
});
}