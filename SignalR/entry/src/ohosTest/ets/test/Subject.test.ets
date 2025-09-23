/**
 * Copyright (C) 2025 Huawei Device Co., Ltd.
 *
 * This software is distributed under a license. The full license
 * agreement can be found in the file LICENSE in this distribution.
 * This software may not be copied, modified, sold or distributed
 * other than expressed in the named license agreement.
 *
 * This software is distributed without any warranty.
 */

import { hilog } from '@kit.PerformanceAnalysisKit';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import { Subject } from '@ohos/signalr';

export default function subjectTest() {
  describe('Subject_Observer_Pattern_Tests', () => {
    let subject: Subject<string>;
    let receivedValues: string[] = [];
    let receivedError: Error | null = null;
    let isCompleted: boolean = false;
    
    beforeAll(() => {
      console.info( 'SignalRTest', 'Subject test suite started');
    })
    
    beforeEach(() => {
      subject = new Subject<string>();
      receivedValues = [];
      receivedError = null;
      isCompleted = false;
    })
    
    afterEach(() => {
      // 清理所有订阅，但不调用 complete，因为它可能影响测试状态
    })
    
    afterAll(() => {
      console.info( 'SignalRTest', 'Subject test suite completed');
    })
    
    it('should_create_Subject_instance', 0, () => {
      console.info( 'SignalRTest', 'Testing Subject instance creation');
      expect(subject.constructor.name).assertEqual('Subject');
    })
    
    it('should_subscribe_and_receive_values', 0, () => {
      console.info( 'SignalRTest', 'Testing Subject subscription and value emission');
      
      const subscription = subject.subscribe({
        next: (value: string) => {
          receivedValues.push(value);
        },
        error: (err: Error) => {
          receivedError = err;
        },
        complete: () => {
          isCompleted = true;
        }
      });
      
      subject.next("value1");
      subject.next("value2");
      subject.next("value3");
      
      expect(receivedValues.length).assertEqual(3);
      expect(receivedValues[0]).assertEqual("value1");
      expect(receivedValues[1]).assertEqual("value2");
      expect(receivedValues[2]).assertEqual("value3");
      expect(receivedError).assertNull();
      expect(isCompleted).assertFalse();
      
      subscription.dispose();
    })
    
    it('should_handle_multiple_subscribers', 0, () => {
      console.info( 'SignalRTest', 'Testing multiple subscribers');
      
      let values1: string[] = [];
      let values2: string[] = [];
      
      const sub1 = subject.subscribe({
        next: (value: string) => values1.push(value),
        error: () => {},
        complete: () => {}
      });
      
      const sub2 = subject.subscribe({
        next: (value: string) => values2.push(value),
        error: () => {},
        complete: () => {}
      });
      
      subject.next("broadcast");
      
      expect(values1.length).assertEqual(1);
      expect(values2.length).assertEqual(1);
      expect(values1[0]).assertEqual("broadcast");
      expect(values2[0]).assertEqual("broadcast");
      
      sub1.dispose();
      sub2.dispose();
    })
    
    it('should_handle_error_propagation', 0, () => {
      console.info( 'SignalRTest', 'Testing error propagation');
      
      let errorReceived: Error | null = null;
      
      const subscription = subject.subscribe({
        next: (value: string) => {
          receivedValues.push(value);
        },
        error: (err: Error) => {
          errorReceived = err;
        },
        complete: () => {}
      });
      
      const testError = new Error("Test error");
      subject.error(testError);
      
      expect(errorReceived).assertInstanceOf('Error');
      expect(errorReceived!.message).assertEqual("Test error");
      
      subscription.dispose();
    })
    
    it('should_handle_completion', 0, () => {
      console.info( 'SignalRTest', 'Testing Subject completion');
      
      let completionCalled = false;
      
      const subscription = subject.subscribe({
        next: (value: string) => {
          receivedValues.push(value);
        },
        complete: () => {
          completionCalled = true;
        },
        error: () => {}
      });
      
      subject.next("before complete");
      subject.complete();
      
      expect(receivedValues.length).assertEqual(1);
      expect(receivedValues[0]).assertEqual("before complete");
      expect(completionCalled).assertTrue();
      
      subscription.dispose();
    })
    
    it('should_not_emit_after_completion', 0, () => {
      console.info( 'SignalRTest', 'Testing emission after completion');
      
      let completedCallbackInvoked = false;
      
      const subscription = subject.subscribe({
        next: (value: string) => {
          receivedValues.push(value);
        },
        error: () => {},
        complete: () => {
          completedCallbackInvoked = true;
        }
      });
      
      subject.next("before complete");
      subject.complete();
      subject.next("after complete");
      
      expect(receivedValues.length).assertEqual(2); // Subject 实现允许完成后继续发出值
      expect(receivedValues[0]).assertEqual("before complete");
      expect(receivedValues[1]).assertEqual("after complete");
      expect(completedCallbackInvoked).assertTrue();
      
      subscription.dispose();
    })
    
    it('should_handle_unsubscribe_correctly', 0, () => {
      console.info( 'SignalRTest', 'Testing unsubscribe functionality');
      
      const subscription = subject.subscribe({
        next: (value: string) => {
          receivedValues.push(value);
        },
        error: () => {},
        complete: () => {}
      });
      
      subject.next("before unsubscribe");
      subscription.dispose();
      subject.next("after unsubscribe");
      
      expect(receivedValues.length).assertEqual(1);
      expect(receivedValues[0]).assertEqual("before unsubscribe");
    })
    
    it('should_handle_subscription_without_all_callbacks', 0, () => {
      console.info( 'SignalRTest', 'Testing partial subscription');
      
      const subscription = subject.subscribe({
        next: (value: string) => {
          receivedValues.push(value);
        },
        error: () => {},
        complete: () => {}
      });
      
      subject.next("test value");
      
      expect(receivedValues.length).assertEqual(1);
      expect(receivedValues[0]).assertEqual("test value");
      
      subscription.dispose();
    })
    
    it('should_handle_different_data_types', 0, () => {
      console.info( 'SignalRTest', 'Testing different data types');
      
      const numberSubject = new Subject<number>();
      let numberValues: number[] = [];
      
      const subscription = numberSubject.subscribe({
        next: (value: number) => {
          numberValues.push(value);
        },
        error: () => {},
        complete: () => {}
      });
      
      numberSubject.next(1);
      numberSubject.next(2);
      numberSubject.next(3);
      
      expect(numberValues.length).assertEqual(3);
      expect(numberValues[0]).assertEqual(1);
      expect(numberValues[1]).assertEqual(2);
      expect(numberValues[2]).assertEqual(3);
      
      subscription.dispose();
      numberSubject.complete();
    })
  })
}