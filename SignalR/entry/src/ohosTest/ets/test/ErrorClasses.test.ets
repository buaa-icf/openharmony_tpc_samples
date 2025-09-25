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
import { AbortError, HttpError, TimeoutError } from '@ohos/signalr';

export default function errorClassesTest() {
  describe('Error_Classes_Tests', () => {
    
    beforeAll(() => {
      console.info( 'SignalRTest', 'Error classes test suite started');
    })
    
    afterAll(() => {
      console.info( 'SignalRTest', 'Error classes test suite completed');
    })
    
    describe('AbortError_Tests', () => {
      it('should_create_AbortError_with_default_message', 0, () => {
        console.info( 'SignalRTest', 'Testing AbortError with default message');
        
        const error = new AbortError();
        
        expect(error.constructor.name).assertEqual('AbortError');
        expect(error instanceof Error).assertTrue();
        expect(error.name).assertEqual('AbortError');
        expect(typeof error.message).assertEqual('string');
      })
      
      it('should_create_AbortError_with_custom_message', 0, () => {
        console.info( 'SignalRTest', 'Testing AbortError with custom message');
        
        const customMessage = 'Connection was aborted by user';
        const error = new AbortError(customMessage);
        
        expect(error.constructor.name).assertEqual('AbortError');
        expect(error.name).assertEqual('AbortError');
        expect(error.message).assertEqual(customMessage);
      })
      
      it('should_have_stack_trace', 0, () => {
        console.info( 'SignalRTest', 'Testing AbortError stack trace');
        
        const error = new AbortError('Test abort');
        
        expect(typeof error.stack).assertEqual('string');
        expect(error.stack?.length || 0).assertLarger(0);
      })
    })
    
    describe('HttpError_Tests', () => {
      it('should_create_HttpError_with_message_and_status_code', 0, () => {
        console.info( 'SignalRTest', 'Testing HttpError with message and status code');
        
        const message = 'Not Found';
        const statusCode = 404;
        const error = new HttpError(message, statusCode);
        
        expect(error.constructor.name).assertEqual('HttpError');
        expect(error instanceof Error).assertTrue();
        expect(error.name).assertEqual('HttpError');
        expect(error.message).assertContain(message);
        expect(error.statusCode).assertEqual(statusCode);
      })
      
      it('should_create_HttpError_with_different_status_codes', 0, () => {
        console.info( 'SignalRTest', 'Testing HttpError with different status codes');
        
        interface TestCase {
          message: string;
          code: number;
        }
        
        const testCases: TestCase[] = [
          { message: 'Bad Request', code: 400 },
          { message: 'Unauthorized', code: 401 },
          { message: 'Forbidden', code: 403 },
          { message: 'Internal Server Error', code: 500 }
        ];
        
        testCases.forEach((testCase) => {
          const error = new HttpError(testCase.message, testCase.code);
          expect(error.statusCode).assertEqual(testCase.code);
          expect(error.message).assertContain(testCase.message);
        });
      })
      
      it('should_handle_zero_status_code', 0, () => {
        console.info( 'SignalRTest', 'Testing HttpError with zero status code');
        
        const error = new HttpError('Network error', 0);
        
        expect(error.statusCode).assertEqual(0);
        expect(error.message).assertContain('Network error');
      })
      
      it('should_have_stack_trace', 0, () => {
        console.info( 'SignalRTest', 'Testing HttpError stack trace');
        
        const error = new HttpError('Test HTTP error', 500);
        
        expect(typeof error.stack).assertEqual('string');
        expect(error.stack?.length || 0).assertLarger(0);
      })
    })
    
    describe('TimeoutError_Tests', () => {
      it('should_create_TimeoutError_with_default_message', 0, () => {
        console.info( 'SignalRTest', 'Testing TimeoutError with default message');
        
        const error = new TimeoutError();
        
        expect(error.constructor.name).assertEqual('TimeoutError');
        expect(error instanceof Error).assertTrue();
        expect(error.name).assertEqual('TimeoutError');
        expect(typeof error.message).assertEqual('string');
      })
      
      it('should_create_TimeoutError_with_custom_message', 0, () => {
        console.info( 'SignalRTest', 'Testing TimeoutError with custom message');
        
        const customMessage = 'Connection timeout after 30 seconds';
        const error = new TimeoutError(customMessage);
        
        expect(error.constructor.name).assertEqual('TimeoutError');
        expect(error.name).assertEqual('TimeoutError');
        expect(error.message).assertEqual(customMessage);
      })
      
      it('should_have_stack_trace', 0, () => {
        console.info( 'SignalRTest', 'Testing TimeoutError stack trace');
        
        const error = new TimeoutError('Test timeout');
        
        expect(typeof error.stack).assertEqual('string');
        expect(error.stack?.length || 0).assertLarger(0);
      })
    })
    
    describe('Error_Inheritance_Tests', () => {
      it('should_maintain_proper_inheritance_chain', 0, () => {
        console.info( 'SignalRTest', 'Testing error inheritance chain');
        
        const abortError = new AbortError('test');
        const httpError = new HttpError('test', 404);
        const timeoutError = new TimeoutError('test');
        
        expect(abortError instanceof Error).assertTrue();
        expect(httpError instanceof Error).assertTrue();
        expect(timeoutError instanceof Error).assertTrue();
        
        expect(abortError.constructor.name).assertEqual('AbortError');
        expect(httpError.constructor.name).assertEqual('HttpError');
        expect(timeoutError.constructor.name).assertEqual('TimeoutError');
        
        expect(abortError.constructor.name === 'HttpError').assertFalse();
        expect(httpError.constructor.name === 'AbortError').assertFalse();
        expect(timeoutError.constructor.name === 'AbortError').assertFalse();
      })
      
      it('should_be_catchable_as_Error', 0, () => {
        console.info( 'SignalRTest', 'Testing error catching');
        
        const errors = [
          new AbortError('abort test'),
          new HttpError('http test', 500),
          new TimeoutError('timeout test')
        ];
        
        errors.forEach((error) => {
          try {
            throw error as Error;
          } catch (caughtError) {
            expect(caughtError instanceof Error).assertTrue();
            expect(typeof caughtError.message).assertEqual('string');
            expect(caughtError.message.length).assertLarger(0);
          }
        });
      })
    })
    
    describe('Error_Serialization_Tests', () => {
      it('should_convert_to_string_properly', 0, () => {
        console.info( 'SignalRTest', 'Testing error string conversion');
        
        const abortError = new AbortError('Connection aborted');
        const httpError = new HttpError('Not found', 404);
        const timeoutError = new TimeoutError('Request timeout');
        
        const abortStr = abortError.toString();
        const httpStr = httpError.toString();
        const timeoutStr = timeoutError.toString();
        
        expect(abortStr).assertContain('Connection aborted');
        expect(httpStr).assertContain('Not found');
        expect(timeoutStr).assertContain('Request timeout');
      })
    })
  })
}