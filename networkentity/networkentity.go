package networkentity

import (
	"net"

	"github.com/metagogs/gogs/acceptor"
)

// NetworkEntity is a network entity that can be used in session
type NetworkEntity interface {
	GetId() int64                    // get the id of the network entity
	Stop() error                     // stop the network entity
	Send(in interface{}) error       // send message with network entity
	RemoteAddr() net.Addr            // get the network entity's remote address
	LocalAddr() net.Addr             // get the network entity's local address
	GetLastTimeOnline() int64        // get the last time online
	GetLatency() int64               // get the latency
	GetConnInfo() *acceptor.ConnInfo // get the connection info
}
