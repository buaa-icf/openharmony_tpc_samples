import { describe, expect, beforeEach } from '../hypium';
import { it } from '../It'
import { Notification, Subscriber } from 'rxjs';
import { TestScheduler } from 'rxjs/testing';
import { observableMatcher } from '../spec/helpers/observableMatcher';

export default function NotificationTest() {
  /** @test {Notification} */
  describe('Notification', () => {
    let rxTestScheduler: TestScheduler;
    beforeEach(() => {
      rxTestScheduler = new TestScheduler(observableMatcher);
    });

    it('should exist', () => {
      expect(Notification != undefined && Notification != null).assertTrue();
      expect(Notification instanceof Function).assertTrue();
    });

    it('should not allow convert to observable if given kind is unknown', () => {
      let error: any = null;
      const n = new Notification('x' as any);
      try {
        n.toObservable()
      } catch (err) {
        error = err;
      }
      expect(error != null).assertTrue();
    });

    it('createNext:should return a Notification', () => {
      const n = Notification.createNext('test');
      expect(n instanceof Notification).assertTrue();
      expect(n.value).assertEqual('test');
      expect(n.kind).assertEqual('N');
      expect(n.error).assertUndefined();
      expect(n.hasValue).assertTrue();
    });


    it('createError:should return a Notification', () => {
      const n = Notification.createError('test');
      expect(n instanceof Notification).assertTrue();
      expect(n.value).assertUndefined();
      expect(n.kind).assertEqual('E');
      expect(n.error).assertEqual('test');
      expect(n.hasValue).assertFalse();
    });


    it('createComplete:should return a Notification', () => {
      const n = Notification.createComplete();
      expect(n instanceof Notification).assertTrue();
      expect(n.value).assertUndefined();
      expect(n.kind).assertEqual('C');
      expect(n.error).assertUndefined();
      expect(n.hasValue).assertFalse();
    });


    it('toObservable:should create observable from a next Notification', () => {
      rxTestScheduler.run(({ expectObservable }) => {
        const value = 'a';
        const next = Notification.createNext(value);
        expectObservable(next.toObservable()).toBe('(a|)');
      });
    });

    it('toObservable:should create observable from a complete Notification', () => {
      rxTestScheduler.run(({ expectObservable }) => {
        const complete = Notification.createComplete();
        expectObservable(complete.toObservable()).toBe('|');
      });
    });

    it('toObservable:should create observable from a error Notification', () => {
      rxTestScheduler.run(({ expectObservable }) => {
        const error = Notification.createError('error');
        expectObservable(error.toObservable()).toBe('#');
      });
    });

    it('static reference:should create new next Notification with value', () => {
      const value = 'a';
      const first = Notification.createNext(value);
      const second = Notification.createNext(value);

      expect(first === second).assertFalse();
    });

    it('static reference:should create new error Notification', () => {
      const first = Notification.createError();
      const second = Notification.createError();

      expect(first === second).assertFalse();
    });

    it('static reference:should return static complete Notification reference', () => {
      const first = Notification.createComplete();
      const second = Notification.createComplete();

      expect(first).assertEqual(second);
    });

    it('do:should invoke on next', () => {
      const n = Notification.createNext('a');
      let invoked = false;
      n.do(
        () => {
          invoked = true;
        },
        () => {
          throw 'should not be called';
        },
        () => {
          throw 'should not be called';
        }
      );

      expect(invoked).assertTrue();
    });

    it('do:should invoke on error', () => {
      const n = Notification.createError();
      let invoked = false;
      n.do(
        () => {
          throw 'should not be called';
        },
        () => {
          invoked = true;
        },
        () => {
          throw 'should not be called';
        }
      );

      expect(invoked).assertTrue();
    });

    it('do:should invoke on complete', () => {
      const n = Notification.createComplete();
      let invoked = false;
      n.do(
        () => {
          throw 'should not be called';
        },
        () => {
          throw 'should not be called';
        },
        () => {
          invoked = true;
        }
      );

      expect(invoked).assertTrue();
    });


    it('accept:should accept observer for next Notification', () => {
      const value = 'a';
      let observed = false;
      const n = Notification.createNext(value);
      const observer = Subscriber.create(
        (x?: string) => {
          expect(x).assertEqual(value);
          observed = true;
        },
        () => {
          throw 'should not be called';
        },
        () => {
          throw 'should not be called';
        }
      );

      n.accept(observer);
      expect(observed).assertTrue();
    });

    it('accept:should accept observer for error Notification', () => {
      let observed = false;
      const n = Notification.createError();
      const observer = Subscriber.create(
        () => {
          throw 'should not be called';
        },
        () => {
          observed = true;
        },
        () => {
          throw 'should not be called';
        }
      );

      n.accept(observer);
      expect(observed).assertTrue();
    });

    it('accept:should accept observer for complete Notification', () => {
      let observed = false;
      const n = Notification.createComplete();
      const observer = Subscriber.create(
        () => {
          throw 'should not be called';
        },
        () => {
          throw 'should not be called';
        },
        () => {
          observed = true;
        }
      );

      n.accept(observer);
      expect(observed).assertTrue();
    });

    it('accept:should accept function for next Notification', () => {
      const value = 'a';
      let observed = false;
      const n = Notification.createNext(value);

      n.accept(
        (x: string) => {
          expect(x).assertEqual(value);
          observed = true;
        },
        () => {
          throw 'should not be called';
        },
        () => {
          throw 'should not be called';
        }
      );
      expect(observed).assertTrue();
    });

    it('accept:should accept function for error Notification', () => {
      let observed = false;
      const error = 'error';
      const n = Notification.createError(error);

      n.accept(
        () => {
          throw 'should not be called';
        },
        (err: any) => {
          expect(err).assertEqual(error);
          observed = true;
        },
        () => {
          throw 'should not be called';
        }
      );
      expect(observed).assertTrue();
    });

    it('accept:should accept function for complete Notification', () => {
      let observed = false;
      const n = Notification.createComplete();

      n.accept(
        () => {
          throw 'should not be called';
        },
        () => {
          throw 'should not be called';
        },
        () => {
          observed = true;
        }
      );
      expect(observed).assertTrue();
    });


    it('observe:should observe for next Notification', () => {
      const value = 'a';
      let observed = false;
      const n = Notification.createNext(value);
      const observer = Subscriber.create(
        (x?: string) => {
          expect(x).assertEqual(value);
          observed = true;
        },
        () => {
          throw 'should not be called';
        },
        () => {
          throw 'should not be called';
        }
      );

      n.observe(observer);
      expect(observed).assertTrue();
    });

    it('observe:should observe for error Notification', () => {
      let observed = false;
      const n = Notification.createError();
      const observer = Subscriber.create(
        () => {
          throw 'should not be called';
        },
        () => {
          observed = true;
        },
        () => {
          throw 'should not be called';
        }
      );

      n.observe(observer);
      expect(observed).assertTrue();
    });

    it('observe:should observe for complete Notification', () => {
      let observed = false;
      const n = Notification.createComplete();
      const observer = Subscriber.create(
        () => {
          throw 'should not be called';
        },
        () => {
          throw 'should not be called';
        },
        () => {
          observed = true;
        }
      );

      n.observe(observer);
      expect(observed).assertTrue();
    });
  });
}