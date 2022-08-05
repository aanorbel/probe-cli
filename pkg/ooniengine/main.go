package main

//
// C API
//

//#include <limits.h>
//#include <stdlib.h>
//
//#include "engine.h"
import "C"

import (
	"errors"
	"log"
	"sync"
	"time"
	"unsafe"

	"google.golang.org/protobuf/proto"
)

// parse parses a user-provided OONIMessage.
func parse(msg *C.struct_OONIMessage) (key string, value []byte, err error) {
	if msg == nil {
		return "", nil, errors.New("msg cannot be NULL")
	}
	if msg.Key == nil {
		return "", nil, errors.New("msg.Key cannot be NULL")
	}
	if msg.Base == nil {
		return "", nil, errors.New("msg.Base cannot be NULL")
	}
	if msg.Size > C.INT_MAX {
		return "", nil, errors.New("msg.Size is too large for C.int")
	}
	value = []byte{}
	if msg.Size > 0 {
		value = C.GoBytes(unsafe.Pointer(msg.Base), C.int(msg.Size))
	}
	key = C.GoString(msg.Key)
	return key, value, nil
}

// serialize serializes a OONIMessage for returning it to C code. This
// function returns a null pointer in case of errors.
func serialize(msg *goMessage) (out *C.struct_OONIMessage) {
	if msg == nil {
		// error message already printed
		return nil
	}
	data, err := proto.Marshal(msg.value)
	if err != nil {
		log.Printf("serialieMessage: cannot serialize message: %s", err.Error())
		return nil
	}
	// Implementation note: we cannot use UINT32_MAX here because int is
	// int32_t on 32 bit platforms, so UINT32_MAX is too large.
	if len(data) > C.INT32_MAX {
		log.Printf("serialieMessage: serialized buffer too large for C.int32")
		return nil
	}
	out = (*C.struct_OONIMessage)(C.malloc(C.sizeof_struct_OONIMessage))
	out.Key = C.CString(msg.key)
	out.Base = (*C.uint8_t)(C.CBytes(data))
	out.Size = C.uint32_t(len(data))
	return out
}

//export OONICall
func OONICall(req *C.struct_OONIMessage) (resp *C.struct_OONIMessage) {
	key, val, err := parse(req)
	if err != nil {
		log.Printf("OONICall: %s", err.Error())
		return nil
	}
	switch key {
	case "ExperimentMetaInfo":
		return serialize(experimentMetaInfoCall(val))
	default:
		log.Printf("OONICall: unknown method name: %s", key)
		return nil
	}
}

var (
	// tasksMu provides mutual exclusion.
	tasksMu sync.Mutex

	// tasksMap keeps alive all the running tasks.
	tasksMap = map[uintptr]taskAPI{}

	// nextTaskHandle is the next task handle.
	nextTaskHandle uintptr
)

const (
	// invalidTaskHandle represents the invalid task handle.
	invalidTaskHandle = 0
)

//export OONITaskStart
func OONITaskStart(cfg *C.struct_OONIMessage) C.OONITask {
	key, value, err := parse(cfg)
	if err != nil {
		log.Printf("OONITaskStart: %s", err.Error())
		return invalidTaskHandle
	}
	tp := startTask(key, value)
	if tp == nil {
		log.Print("OONITaskStart: startTask returned NULL")
		return invalidTaskHandle
	}
	defer tasksMu.Unlock()
	tasksMu.Lock()
	nextTaskHandle++
	handle := nextTaskHandle
	if handle == invalidTaskHandle {
		log.Printf("OONITaskStart: ran out of handle space")
		return invalidTaskHandle
	}
	tasksMap[handle] = tp
	return C.OONITask(handle)
}

//export OONITaskWaitForNextEvent
func OONITaskWaitForNextEvent(task C.OONITask, timeout C.int32_t) *C.struct_OONIMessage {
	tasksMu.Lock()
	tp := tasksMap[uintptr(task)]
	tasksMu.Unlock()
	if tp == nil {
		log.Printf("OONITaskWaitForNextEvent: no such task: %d", task)
		return nil
	}
	ev := tp.waitForNextEvent(time.Duration(timeout) * time.Millisecond)
	return serialize(ev)
}

//export OONIMessageFree
func OONIMessageFree(event *C.struct_OONIMessage) {
	if event != nil {
		C.free(unsafe.Pointer(event.Key))
		C.free(unsafe.Pointer(event.Base))
	}
	C.free(unsafe.Pointer(event))
}

//export OONITaskIsDone
func OONITaskIsDone(task C.OONITask) (out C.uint8_t) {
	tasksMu.Lock()
	tp := tasksMap[uintptr(task)]
	tasksMu.Unlock()
	if tp == nil || tp.isDone() {
		if tp == nil {
			log.Printf("OONITaskWaitForNextEvent: no such task: %d", task)
		}
		out++ // set to true
	}
	return
}

//export OONITaskInterrupt
func OONITaskInterrupt(task C.OONITask) {
	tasksMu.Lock()
	tp := tasksMap[uintptr(task)]
	tasksMu.Unlock()
	if tp == nil {
		// No need to print a warning message here. We want logging
		// idempotence because may may end up killing a task more
		// than once for robustness and we don't want our robustness
		// aims to spew suspicious messages at our users.
		return
	}
	tp.interrupt()
}

//export OONITaskFree
func OONITaskFree(task C.OONITask) {
	tasksMu.Lock()
	tp := tasksMap[uintptr(task)]
	delete(tasksMap, uintptr(task)) // this forgets the ID->task binding
	tasksMu.Unlock()
	if tp == nil {
		// No need to print a warning message here. We want logging
		// idempotence because may may end up killing a task more
		// than once for robustness and we don't want our robustness
		// aims to spew suspicious messages at our users.
		return
	}
	tp.free()
}

func main() {}
