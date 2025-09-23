// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

import { hilog } from '@kit.PerformanceAnalysisKit';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import { 
  AckMessage, 
  CloseMessage, 
  CompletionMessage, 
  InvocationMessage, 
  MessageType, 
  SequenceMessage, 
  StreamItemMessage,
  JsonHubProtocol,
  ILogger,
  LogLevel
} from '@ohos/signalr';
import { TextMessageFormat } from '@ohos/signalr/src/main/ets/src/TextMessageFormat';

// Mock VerifyLogger for HarmonyOS
class VerifyLogger {
  static async run(callback: (logger: ILogger) => Promise<void>): Promise<void> {
    const logger: ILogger = {
      log: (logLevel: LogLevel, message: string) => console.info( 'SignalRTest', `[${LogLevel[logLevel]}] ${message}`)
    };
    await callback(logger);
  }
}

export default function jsonHubProtocolTest() {
  describe("JsonHubProtocol", () => {
    beforeAll(() => {
      console.info( 'SignalRTest', 'JsonHubProtocol test suite started');
    });

    afterAll(() => {
      console.info( 'SignalRTest', 'JsonHubProtocol test suite completed');
    });

    it("can write/read non-blocking Invocation message", 0, async () => {
      await VerifyLogger.run(async (logger: ILogger) => {
        const invocation = {
          arguments: [42, true, "test", ["x1", "y2"], null],
          headers: {},
          target: "myMethod",
          type: MessageType.Invocation,
        } as InvocationMessage;

        const protocol = new JsonHubProtocol();
        const parsedMessages = protocol.parseMessages(protocol.writeMessage(invocation), logger);
        expect(parsedMessages).assertDeepEquals([invocation]);
      });
    });

    it("can read Invocation message with Date argument", 0, async () => {
      await VerifyLogger.run(async (logger: ILogger) => {
        const invocation = {
          arguments: [Date.UTC(2018, 1, 1, 12, 34, 56)],
          headers: {},
          target: "mymethod",
          type: MessageType.Invocation,
        } as InvocationMessage;

        const protocol = new JsonHubProtocol();
        const parsedMessages = protocol.parseMessages(protocol.writeMessage(invocation), logger);
        expect(parsedMessages).assertDeepEquals([invocation]);
      });
    });

    it("can write/read Invocation message with headers", 0, async () => {
      await VerifyLogger.run(async (logger: ILogger) => {
        const invocation = {
          arguments: [42, true, "test", ["x1", "y2"], null],
          headers: {
            foo: "bar",
          },
          streamIds: [],
          target: "myMethod",
          type: MessageType.Invocation,
        } as InvocationMessage;

        const protocol = new JsonHubProtocol();
        const parsedMessages = protocol.parseMessages(protocol.writeMessage(invocation), logger);
        expect(parsedMessages).assertDeepEquals([invocation]);
      });
    });

    it("can write/read Invocation message", 0, async () => {
      await VerifyLogger.run(async (logger: ILogger) => {
        const invocation = {
          arguments: [42, true, "test", ["x1", "y2"], null],
          headers: {},
          invocationId: "123",
          target: "myMethod",
          type: MessageType.Invocation,
        } as InvocationMessage;

        const protocol = new JsonHubProtocol();
        const parsedMessages = protocol.parseMessages(protocol.writeMessage(invocation), logger);
        expect(parsedMessages).assertDeepEquals([invocation]);
      });
    });

    // Completion message tests
    const completionTestCases: [string, CompletionMessage][] = [
      [`{"type":3, "invocationId": "abc", "error": "Err", "result": null, "headers": {}}${TextMessageFormat.RecordSeparator}`,
      {
        error: "Err",
        headers: {},
        invocationId: "abc",
        result: null,
        type: MessageType.Completion,
      } as CompletionMessage],
      [`{"type":3, "invocationId": "abc", "result": "OK", "headers": {}}${TextMessageFormat.RecordSeparator}`,
      {
        headers: {},
        invocationId: "abc",
        result: "OK",
        type: MessageType.Completion,
      } as CompletionMessage],
      [`{"type":3, "invocationId": "abc", "result": null, "headers": {}}${TextMessageFormat.RecordSeparator}`,
      {
        headers: {},
        invocationId: "abc",
        result: null,
        type: MessageType.Completion,
      } as CompletionMessage],
      [`{"type":3, "invocationId": "abc", "result": 1514805840000, "headers": {}}${TextMessageFormat.RecordSeparator}`,
      {
        headers: {},
        invocationId: "abc",
        result: Date.UTC(2018, 0, 1, 11, 24, 0),
        type: MessageType.Completion,
      } as CompletionMessage],
      [`{"type":3, "invocationId": "abc", "result": null, "headers": {}, "extraParameter":"value"}${TextMessageFormat.RecordSeparator}`,
      {
        extraParameter: "value",
        headers: {},
        invocationId: "abc",
        result: null,
        type: MessageType.Completion,
      } as CompletionMessage],
    ];

    completionTestCases.forEach((testCase: [string, CompletionMessage], index: number) => {
      it(`can read Completion message ${index + 1}`, 0, async () => {
        await VerifyLogger.run(async (logger: ILogger) => {
          const payload = testCase[0];
          const expectedMessage = testCase[1];
          const messages = new JsonHubProtocol().parseMessages(payload, logger);
          expect(messages).assertDeepEquals([expectedMessage]);
        });
      });
    });

    // StreamItem message tests
    const streamItemTestCases: [string, StreamItemMessage][] = [
      [`{"type":2, "invocationId": "abc", "headers": {}, "item": 8}${TextMessageFormat.RecordSeparator}`,
      {
        headers: {},
        invocationId: "abc",
        item: 8,
        type: MessageType.StreamItem,
      } as StreamItemMessage],
      [`{"type":2, "invocationId": "abc", "headers": {}, "item": 1514805840000}${TextMessageFormat.RecordSeparator}`,
      {
        headers: {},
        invocationId: "abc",
        item: Date.UTC(2018, 0, 1, 11, 24, 0),
        type: MessageType.StreamItem,
      } as StreamItemMessage],
    ];

    streamItemTestCases.forEach((testCase: [string, StreamItemMessage], index: number) => {
      it(`can read StreamItem message ${index + 1}`, 0, async () => {
        await VerifyLogger.run(async (logger: ILogger) => {
          const payload = testCase[0];
          const expectedMessage = testCase[1];
          const messages = new JsonHubProtocol().parseMessages(payload, logger);
          expect(messages).assertDeepEquals([expectedMessage]);
        });
      });
    });

    // Message with headers test
    const headerTestCases: [string, StreamItemMessage][] = [
      [`{"type":2, "invocationId": "abc", "headers": {"t": "u"}, "item": 8}${TextMessageFormat.RecordSeparator}`,
      {
        headers: {
          t: "u",
        },
        invocationId: "abc",
        item: 8,
        type: MessageType.StreamItem,
      } as StreamItemMessage],
    ];

    headerTestCases.forEach((testCase: [string, StreamItemMessage], index: number) => {
      it(`can read message with headers ${index + 1}`, 0, async () => {
        await VerifyLogger.run(async (logger: ILogger) => {
          const payload = testCase[0];
          const expectedMessage = testCase[1];
          const messages = new JsonHubProtocol().parseMessages(payload, logger);
          expect(messages).assertDeepEquals([expectedMessage]);
        });
      });
    });

    // Error handling tests
    const errorTestCases: [string, string, string][] = [
      ["message with empty payload", `{}${TextMessageFormat.RecordSeparator}`, "Invalid payload."],
      ["Invocation message with invalid invocation id", `{"type":1,"invocationId":1,"target":"method"}${TextMessageFormat.RecordSeparator}`, "Invalid payload for Invocation message."],
      ["Invocation message with empty string invocation id", `{"type":1,"invocationId":"","target":"method"}${TextMessageFormat.RecordSeparator}`, "Invalid payload for Invocation message."],
      ["Invocation message with invalid target", `{"type":1,"invocationId":"1","target":1}${TextMessageFormat.RecordSeparator}`, "Invalid payload for Invocation message."],
      ["StreamItem message with missing invocation id", `{"type":2}${TextMessageFormat.RecordSeparator}`, "Invalid payload for StreamItem message."],
      ["StreamItem message with invalid invocation id", `{"type":2,"invocationId":1}${TextMessageFormat.RecordSeparator}`, "Invalid payload for StreamItem message."],
      ["Completion message with missing invocation id", `{"type":3}${TextMessageFormat.RecordSeparator}`, "Invalid payload for Completion message."],
      ["Completion message with invalid invocation id", `{"type":3,"invocationId":1}${TextMessageFormat.RecordSeparator}`, "Invalid payload for Completion message."],
      ["Completion message with result and error", `{"type":3,"invocationId":"1","result":2,"error":"error"}${TextMessageFormat.RecordSeparator}`, "Invalid payload for Completion message."],
      ["Completion message with non-string error", `{"type":3,"invocationId":"1","error":21}${TextMessageFormat.RecordSeparator}`, "Invalid payload for Completion message."],
    ];

    errorTestCases.forEach((testCase: [string, string, string]) => {
      it(`throws for ${testCase[0]}`, 0, async () => {
        await VerifyLogger.run(async (logger: ILogger) => {
          const name = testCase[0];
          const payload = testCase[1];
          const expectedError = testCase[2];
          try {
            new JsonHubProtocol().parseMessages(payload, logger);
            expect(false).assertTrue(); // Should not reach here
          } catch (error) {
            expect((error as Error).message).assertContain(expectedError);
          }
        });
      });
    });

    it("can read multiple messages", 0, async () => {
      await VerifyLogger.run(async (logger: ILogger) => {
        const payload = `{"type":2, "invocationId": "abc", "headers": {}, "item": 8}${TextMessageFormat.RecordSeparator}{"type":3, "invocationId": "abc", "headers": {}, "result": "OK"}${TextMessageFormat.RecordSeparator}`;
        const messages = new JsonHubProtocol().parseMessages(payload, logger);
        expect(messages).assertDeepEquals([
          {
            headers: {},
            invocationId: "abc",
            item: 8,
            type: MessageType.StreamItem,
          } as StreamItemMessage,
          {
            headers: {},
            invocationId: "abc",
            result: "OK",
            type: MessageType.Completion,
          } as CompletionMessage,
        ]);
      });
    });

    it("can read ping message", 0, async () => {
      await VerifyLogger.run(async (logger: ILogger) => {
        const payload = `{"type":6}${TextMessageFormat.RecordSeparator}`;
        const messages = new JsonHubProtocol().parseMessages(payload, logger);
        expect(messages).assertDeepEquals([
          {
            type: MessageType.Ping,
          },
        ]);
      });
    });

    it("can write/read Close message", 0, async () => {
      await VerifyLogger.run(async (logger: ILogger) => {
        const closeMessage = {
          type: MessageType.Close,
        } as CloseMessage;

        const protocol = new JsonHubProtocol();
        const parsedMessages = protocol.parseMessages(protocol.writeMessage(closeMessage), logger);
        expect(parsedMessages).assertDeepEquals([closeMessage]);
      });
    });

    it("can write/read Ack message", 0, async () => {
      await VerifyLogger.run(async (logger: ILogger) => {
        const ackMessage = {
          sequenceId: 45,
          type: MessageType.Ack,
        } as AckMessage;

        const protocol = new JsonHubProtocol();
        const parsedMessages = protocol.parseMessages(protocol.writeMessage(ackMessage), logger);
        expect(parsedMessages).assertDeepEquals([ackMessage]);
      });
    });

    it("can write/read Sequence message", 0, async () => {
      await VerifyLogger.run(async (logger: ILogger) => {
        const sequenceMessage = {
          sequenceId: 46,
          type: MessageType.Sequence,
        } as SequenceMessage;

        const protocol = new JsonHubProtocol();
        const parsedMessages = protocol.parseMessages(protocol.writeMessage(sequenceMessage), logger);
        expect(parsedMessages).assertDeepEquals([sequenceMessage]);
      });
    });
  });
}