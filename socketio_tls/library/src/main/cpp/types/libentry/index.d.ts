/**
 *
 * This software is distributed under a license. The full license
 * agreement can be found in the file LICENSE in this distribution.
 * This software may not be copied, modified, sold or distributed
 * other than expressed in the named license agreement.
 *
 * This software is distributed without any warranty.
 */

export class newSocketIOClient {
  classId: number;
  set_headers: (headers: string, classId: number) => void;

  set_option: (opts: string, classId: number) => void;

  connect: (uri: string, classId: number) => void;

  set_nsp: (set_nsp: string, classId: number) => void;

  set_open_listener: (open: any, classId: number) => void;

  set_fail_listener: (fail: any, classId: number) => void;

  set_reconnecting_listener: (reconnecting: any, classId: number) => void;

  set_reconnect_listener: (reconnect: any, classId: number) => void;

  set_close_listener: (closeListener: any, classId: number) => void;

  set_socket_open_listener: (socket_open_listener: any, classId: number) => void;

  set_socket_close_listener: (socket_close_listener: any, classId: number) => void;

  clear_con_listeners: (classId: number) => void;

  clear_socket_listeners: (classId: number) => void;

  set_reconnect_attempts: (reconnect_attempts: any, classId: number) => void;

  set_reconnect_delay: (reconnect_delay: any, classId: number) => void;

  set_reconnect_delay_max: (reconnect_delay_max: any, classId: number) => void;

  set_logs_default: (classId: number) => void;


  set_logs_quiet: (classId: number) => void;

  set_logs_verbose: (classId: number) => void;

  close: (classId: number) => void;

  sync_close: (classId: number) => void;

  set_proxy_basic_auth: (uri: string, username: string, password: string, classId: number) => void;

  opened: (classId: number) => boolean;

  get_sessionid: (classId: number) => string;

  on: (event_name: string, on_event_listener: (event_json: string, classId: number) => void, classId: number) => void;

  on_binary: (event_name: string, on_event_listener: (event_data: Uint8Array) => void, classId: number) => void;

  once: (event_name: string, on_event_listener: (event_json: string) => void, classId: number) => void;

  off: (close: any, classId: number) => void;

  off_all: (classId: number) => void;

  socket_close: (classId: number) => void;

  off_error: (classId: number) => void;

  on_error: (on_error_listener: (message: string) => void, classId: number) => void;

  emit: (name: string, message: any,
    on_emit_callback: (emit_callback_json: string) => void, classId: number) => void;

  emitAckBinary: (name: string, message: any, b: boolean,
    on_emit_callback: (code: number, emit_callback_data: Uint8Array) => void, classId: number) => void;
  get_current_state: (classId: number) => number;
}