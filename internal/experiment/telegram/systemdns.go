package telegram

//
// SystemDNS: Resolves web.telegram.org using the system resolver.
//

import (
	"context"
	"sync"
	"time"

	"github.com/ooni/probe-cli/v3/internal/atomicx"
	"github.com/ooni/probe-cli/v3/internal/measurexlite"
	"github.com/ooni/probe-cli/v3/internal/model"
)

// Resolves web.telegram.org using the system resolver.
//
// The zero value of this structure IS NOT valid and you MUST initialize
// all the fields marked as MANDATORY before using this structure.
//
// This task implements the system-resolver template.
type SystemDNSTask struct {
	// Domain is the MANDATORY domain to resolve.
	Domain string

	// IDGenerator is the MANDATORY atomic int64 to generate task IDs.
	IDGenerator *atomicx.Int64

	// Logger is the MANDATORY logger to use.
	Logger model.Logger

	// TestKeys is MANDATORY and contains the TestKeys.
	TestKeys *TestKeys

	// ZeroTime is the MANDATORY measurement's zero time.
	ZeroTime time.Time

	// WaitGroup is the MANDATORY wait group this task belongs to.
	WaitGroup *sync.WaitGroup
}

// Start starts this task in a background gorountine.
func (t *SystemDNSTask) Start(ctx context.Context) {
	t.WaitGroup.Add(1)
	index := t.IDGenerator.Add(1)
	go t.run(ctx, index)
}

// run runs this task in the background.
func (t *SystemDNSTask) run(ctx context.Context, index int64) {
	// synchronize with wait group
	defer t.WaitGroup.Done()

	// configure a timeout
	const defaultTimeout = 4 * time.Second // TODO: change this default
	ctx, cancel := context.WithTimeout(ctx, defaultTimeout)
	defer cancel()

	// create trace
	trace := measurexlite.NewTrace(index, t.ZeroTime)

	// start the operation logger
	ol := measurexlite.NewOperationLogger(t.Logger, "SystemDNS#%d", index) // TODO: edit

	// construct a system resolver.
	reso := trace.NewStdlibResolver(t.Logger)
	addrs, err := reso.LookupHost(ctx, t.Domain)
	_ = trace.DNSLookupsFromRoundTrip() // TODO: save
	if err != nil {
		ol.Stop(err)
		return
	}

	// emit successful log message
	ol.Stop(nil)

	// (typically) fan out a number of child async tasks to use the IP addrs
	for range addrs {
		// TODO: implement
	}
}