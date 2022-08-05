// AUTO GENERATED FILE, DO NOT EDIT.
//
// Generated by `package:ffigen`.
import 'dart:ffi' as ffi;

class OONIEngineFFI {
  /// Holds the symbol lookup function.
  final ffi.Pointer<T> Function<T extends ffi.NativeType>(String symbolName)
      _lookup;

  /// The symbols are looked up in [dynamicLibrary].
  OONIEngineFFI(ffi.DynamicLibrary dynamicLibrary)
      : _lookup = dynamicLibrary.lookup;

  /// The symbols are looked up with [lookup].
  OONIEngineFFI.fromLookup(
      ffi.Pointer<T> Function<T extends ffi.NativeType>(String symbolName)
          lookup)
      : _lookup = lookup;

  /// OONICall calls an OONI engine function and returns the result.
  ///
  /// @param req An OONIMessage structure, owned by the caller, that
  /// describes which API to call and with which arguments. The engine
  /// will use the message Key to determine which function to call. The
  /// engine will reply immediately. It's safe to free [req] once this
  /// function has returned a result to the caller.
  ///
  /// @return A NULL pointer on failure, non-NULL otherwise. If the return
  /// value is non-NULL, the caller takes ownership of the OONIMessage
  /// pointer and MUST free it using OONIMessageFree when done using it.
  ffi.Pointer<OONIMessage> OONICall(
    ffi.Pointer<OONIMessage> req,
  ) {
    return _OONICall(
      req,
    );
  }

  late final _OONICallPtr = _lookup<
      ffi.NativeFunction<
          ffi.Pointer<OONIMessage> Function(
              ffi.Pointer<OONIMessage>)>>('OONICall');
  late final _OONICall = _OONICallPtr.asFunction<
      ffi.Pointer<OONIMessage> Function(ffi.Pointer<OONIMessage>)>();

  /// OONITaskStart starts a new OONITask using the given [cfg].
  ///
  /// @param cfg An OONIMessage structure, owned by the caller, that
  /// contains the configuration for the task to start. The engine will
  /// use the message Key to determine which task to start. The engine
  /// will copy the contents of [cfg], therefore it's safe to free
  /// [cfg] once this function has returned.
  ///
  /// @return Zero on failure, nonzero on success. If the return value
  /// is nonzero, a task is running. In such a case, the caller is
  /// responsible to eventually dispose of the task using OONITaskFree.
  int OONITaskStart(
    ffi.Pointer<OONIMessage> cfg,
  ) {
    return _OONITaskStart(
      cfg,
    );
  }

  late final _OONITaskStartPtr =
      _lookup<ffi.NativeFunction<OONITask Function(ffi.Pointer<OONIMessage>)>>(
          'OONITaskStart');
  late final _OONITaskStart =
      _OONITaskStartPtr.asFunction<int Function(ffi.Pointer<OONIMessage>)>();

  /// OONITaskWaitForNextEvent awaits on the [task] event queue until
  /// a new event is available or the given [timeout] expires.
  ///
  /// @param task Task handle returned by OONITaskStart.
  ///
  /// @param timeout Timeout in milliseconds. If the timeout is zero
  /// or negative, this function would potentially block forever.
  ///
  /// @return A NULL pointer on failure, non-NULL otherwise. If the return
  /// value is non-NULL, the caller takes ownership of the OONIMessage
  /// pointer and MUST free it using OONIMessageFree when done using it.
  ///
  /// This function will return NULL:
  ///
  /// 1. when the timeout expires;
  ///
  /// 2. if [task] is done;
  ///
  /// 3. if [task] is zero or does not refer to a valid task;
  ///
  /// 4. if we cannot protobuf serialize the message;
  ///
  /// 5. possibly because of other unknown internal errors.
  ///
  /// In short, you cannot reliably determine whether a task is done by
  /// checking whether this function has returned NULL.
  ffi.Pointer<OONIMessage> OONITaskWaitForNextEvent(
    int task,
    int timeout,
  ) {
    return _OONITaskWaitForNextEvent(
      task,
      timeout,
    );
  }

  late final _OONITaskWaitForNextEventPtr = _lookup<
      ffi.NativeFunction<
          ffi.Pointer<OONIMessage> Function(
              OONITask, ffi.Int32)>>('OONITaskWaitForNextEvent');
  late final _OONITaskWaitForNextEvent = _OONITaskWaitForNextEventPtr
      .asFunction<ffi.Pointer<OONIMessage> Function(int, int)>();

  /// OONIMessageFree frees a [msg] returned by OONITaskWaitForNextEvent. You MUST
  /// NOT free these messages yourself by calling `free` because the OONI engine MAY
  /// be using a different allocator. In the same vein, you MUST NOT use this
  /// function to free OONIMessages allocated by the app.
  ///
  /// @param msg OONIMessage previousely returned by OONITaskWaitForNextEvent. If
  /// msg is a NULL pointer, this function will just ignore it.
  void OONIMessageFree(
    ffi.Pointer<OONIMessage> msg,
  ) {
    return _OONIMessageFree(
      msg,
    );
  }

  late final _OONIMessageFreePtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(ffi.Pointer<OONIMessage>)>>(
          'OONIMessageFree');
  late final _OONIMessageFree =
      _OONIMessageFreePtr.asFunction<void Function(ffi.Pointer<OONIMessage>)>();

  /// OONITaskIsDone returns whether the task identified by [taskID] is done. A taks is
  /// done when it has finished running _and_ its events queue has been drained.
  ///
  /// @param task Task handle returned by OONITaskStart.
  ///
  /// @return Nonzero if the task exists and either is still running or has some
  /// unread events inside its events queue, zero otherwise.
  int OONITaskIsDone(
    int task,
  ) {
    return _OONITaskIsDone(
      task,
    );
  }

  late final _OONITaskIsDonePtr =
      _lookup<ffi.NativeFunction<ffi.Uint8 Function(OONITask)>>(
          'OONITaskIsDone');
  late final _OONITaskIsDone =
      _OONITaskIsDonePtr.asFunction<int Function(int)>();

  /// OONITaskInterrupt tells [task] to stop ASAP.
  ///
  /// @param task Task handle returned by OONITaskStart. If task is zero
  /// or does not refer to a valid task, this function will just do nothing.
  void OONITaskInterrupt(
    int task,
  ) {
    return _OONITaskInterrupt(
      task,
    );
  }

  late final _OONITaskInterruptPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(OONITask)>>(
          'OONITaskInterrupt');
  late final _OONITaskInterrupt =
      _OONITaskInterruptPtr.asFunction<void Function(int)>();

  /// OONITaskFree free the memory associated with [task]. If the task is still running, this
  /// function will also interrupt it and drain its events queue.
  ///
  /// @param task Task handle returned by OONITaskStart. If task is zero
  /// or does not refer to a valid task, this function will just do nothing.
  void OONITaskFree(
    int task,
  ) {
    return _OONITaskFree(
      task,
    );
  }

  late final _OONITaskFreePtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(OONITask)>>('OONITaskFree');
  late final _OONITaskFree = _OONITaskFreePtr.asFunction<void Function(int)>();
}

class __mbstate_t extends ffi.Union {
  @ffi.Array.multi([128])
  external ffi.Array<ffi.Char> __mbstate8;

  @ffi.LongLong()
  external int _mbstateL;
}

class __darwin_pthread_handler_rec extends ffi.Struct {
  external ffi
          .Pointer<ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>)>>
      __routine;

  external ffi.Pointer<ffi.Void> __arg;

  external ffi.Pointer<__darwin_pthread_handler_rec> __next;
}

class _opaque_pthread_attr_t extends ffi.Struct {
  @ffi.Long()
  external int __sig;

  @ffi.Array.multi([56])
  external ffi.Array<ffi.Char> __opaque;
}

class _opaque_pthread_cond_t extends ffi.Struct {
  @ffi.Long()
  external int __sig;

  @ffi.Array.multi([40])
  external ffi.Array<ffi.Char> __opaque;
}

class _opaque_pthread_condattr_t extends ffi.Struct {
  @ffi.Long()
  external int __sig;

  @ffi.Array.multi([8])
  external ffi.Array<ffi.Char> __opaque;
}

class _opaque_pthread_mutex_t extends ffi.Struct {
  @ffi.Long()
  external int __sig;

  @ffi.Array.multi([56])
  external ffi.Array<ffi.Char> __opaque;
}

class _opaque_pthread_mutexattr_t extends ffi.Struct {
  @ffi.Long()
  external int __sig;

  @ffi.Array.multi([8])
  external ffi.Array<ffi.Char> __opaque;
}

class _opaque_pthread_once_t extends ffi.Struct {
  @ffi.Long()
  external int __sig;

  @ffi.Array.multi([8])
  external ffi.Array<ffi.Char> __opaque;
}

class _opaque_pthread_rwlock_t extends ffi.Struct {
  @ffi.Long()
  external int __sig;

  @ffi.Array.multi([192])
  external ffi.Array<ffi.Char> __opaque;
}

class _opaque_pthread_rwlockattr_t extends ffi.Struct {
  @ffi.Long()
  external int __sig;

  @ffi.Array.multi([16])
  external ffi.Array<ffi.Char> __opaque;
}

class _opaque_pthread_t extends ffi.Struct {
  @ffi.Long()
  external int __sig;

  external ffi.Pointer<__darwin_pthread_handler_rec> __cleanup_stack;

  @ffi.Array.multi([8176])
  external ffi.Array<ffi.Char> __opaque;
}

/// OONIMessage is a message sent to or received from the OONI engine.
class OONIMessage extends ffi.Struct {
  /// Key identifies the message type and allows a protobuf v3
  /// parser to unserialize to the correct value.
  external ffi.Pointer<ffi.Char> Key;

  /// Base is the base pointer of the byte array containing
  /// protobuf v3 serialized data.
  external ffi.Pointer<ffi.Uint8> Base;

  /// Size is the size of the byte array.
  @ffi.Uint32()
  external int Size;
}

/// OONITask is an asynchronous thread of execution managed by the OONI
/// engine that performs a background operation and emits meaningful
/// events such as, for example, the results of measurements.
typedef OONITask = uintptr_t;
typedef uintptr_t = ffi.UnsignedLong;

const int true1 = 1;

const int false1 = 0;

const int __bool_true_false_are_defined = 1;

const int __WORDSIZE = 64;

const int __DARWIN_ONLY_64_BIT_INO_T = 1;

const int __DARWIN_ONLY_UNIX_CONFORMANCE = 1;

const int __DARWIN_ONLY_VERS_1050 = 1;

const int __DARWIN_UNIX03 = 1;

const int __DARWIN_64_BIT_INO_T = 1;

const int __DARWIN_VERS_1050 = 1;

const int __DARWIN_NON_CANCELABLE = 0;

const String __DARWIN_SUF_EXTSN = '\$DARWIN_EXTSN';

const int __DARWIN_C_ANSI = 4096;

const int __DARWIN_C_FULL = 900000;

const int __DARWIN_C_LEVEL = 900000;

const int __STDC_WANT_LIB_EXT1__ = 1;

const int __DARWIN_NO_LONG_LONG = 0;

const int _DARWIN_FEATURE_64_BIT_INODE = 1;

const int _DARWIN_FEATURE_ONLY_64_BIT_INODE = 1;

const int _DARWIN_FEATURE_ONLY_VERS_1050 = 1;

const int _DARWIN_FEATURE_ONLY_UNIX_CONFORMANCE = 1;

const int _DARWIN_FEATURE_UNIX_CONFORMANCE = 3;

const int __has_ptrcheck = 0;

const int __DARWIN_NULL = 0;

const int __PTHREAD_SIZE__ = 8176;

const int __PTHREAD_ATTR_SIZE__ = 56;

const int __PTHREAD_MUTEXATTR_SIZE__ = 8;

const int __PTHREAD_MUTEX_SIZE__ = 56;

const int __PTHREAD_CONDATTR_SIZE__ = 8;

const int __PTHREAD_COND_SIZE__ = 40;

const int __PTHREAD_ONCE_SIZE__ = 8;

const int __PTHREAD_RWLOCK_SIZE__ = 192;

const int __PTHREAD_RWLOCKATTR_SIZE__ = 16;

const int USER_ADDR_NULL = 0;

const int INT8_MAX = 127;

const int INT16_MAX = 32767;

const int INT32_MAX = 2147483647;

const int INT64_MAX = 9223372036854775807;

const int INT8_MIN = -128;

const int INT16_MIN = -32768;

const int INT32_MIN = -2147483648;

const int INT64_MIN = -9223372036854775808;

const int UINT8_MAX = 255;

const int UINT16_MAX = 65535;

const int UINT32_MAX = 4294967295;

const int UINT64_MAX = -1;

const int INT_LEAST8_MIN = -128;

const int INT_LEAST16_MIN = -32768;

const int INT_LEAST32_MIN = -2147483648;

const int INT_LEAST64_MIN = -9223372036854775808;

const int INT_LEAST8_MAX = 127;

const int INT_LEAST16_MAX = 32767;

const int INT_LEAST32_MAX = 2147483647;

const int INT_LEAST64_MAX = 9223372036854775807;

const int UINT_LEAST8_MAX = 255;

const int UINT_LEAST16_MAX = 65535;

const int UINT_LEAST32_MAX = 4294967295;

const int UINT_LEAST64_MAX = -1;

const int INT_FAST8_MIN = -128;

const int INT_FAST16_MIN = -32768;

const int INT_FAST32_MIN = -2147483648;

const int INT_FAST64_MIN = -9223372036854775808;

const int INT_FAST8_MAX = 127;

const int INT_FAST16_MAX = 32767;

const int INT_FAST32_MAX = 2147483647;

const int INT_FAST64_MAX = 9223372036854775807;

const int UINT_FAST8_MAX = 255;

const int UINT_FAST16_MAX = 65535;

const int UINT_FAST32_MAX = 4294967295;

const int UINT_FAST64_MAX = -1;

const int INTPTR_MAX = 9223372036854775807;

const int INTPTR_MIN = -9223372036854775808;

const int UINTPTR_MAX = -1;

const int INTMAX_MAX = 9223372036854775807;

const int UINTMAX_MAX = -1;

const int INTMAX_MIN = -9223372036854775808;

const int PTRDIFF_MIN = -9223372036854775808;

const int PTRDIFF_MAX = 9223372036854775807;

const int SIZE_MAX = -1;

const int RSIZE_MAX = 9223372036854775807;

const int WCHAR_MAX = 2147483647;

const int WCHAR_MIN = -2147483648;

const int WINT_MIN = -2147483648;

const int WINT_MAX = 2147483647;

const int SIG_ATOMIC_MIN = -2147483648;

const int SIG_ATOMIC_MAX = 2147483647;