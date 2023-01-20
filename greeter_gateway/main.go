package main

import (
	"flag"
	"fmt"
	"log"
	"net/http"
	"os"

	"github.com/golang/glog"
	"github.com/grpc-ecosystem/grpc-gateway/v2/runtime"
	"golang.org/x/net/context"
	"google.golang.org/grpc"

	gw "local.packages/pb"
	// --- for health check
	healthGw "local.packages/pb_health"
	// ---
)

func run() error {
	ctx := context.Background()
	ctx, cancel := context.WithCancel(ctx)
	defer cancel()

	mux := runtime.NewServeMux()
	opts := []grpc.DialOption{grpc.WithInsecure()}
	endpoint := os.Getenv("GRPC_GATEWAY_ENDPOINT")
	log.Printf("Endpoint: %v", endpoint)
	if endpoint == "" {
		log.Printf("Then, endpoint is reset to localhost:5001.")
		endpoint = fmt.Sprintf("localhost:5001")
	}
	err := gw.RegisterHelloWorldServiceHandlerFromEndpoint(ctx, mux, endpoint, opts)
	if err != nil {
		return err
	}
	// --- for health check
	err = healthGw.RegisterDemoHealthHandlerFromEndpoint(ctx, mux, endpoint, opts)
	if err != nil {
		return err
	}
	// ---

	return http.ListenAndServe(":15000", mux)
}

func main() {
	flag.Parse()
	defer glog.Flush()

	if err := run(); err != nil {
		glog.Fatal(err)
	}
}
