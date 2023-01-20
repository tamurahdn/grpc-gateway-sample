package main

import (
	"context"
	"log"
	"net"

	"google.golang.org/grpc"
	// --- for health check
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"

	// ---
	pb "local.packages/pb"
	// --- for health check
	health "local.packages/pb_health"
	// ---
)

const (
	port = ":5001"
)

// server is used to implement HelloWorldServer.
type server struct{}

// SayHello implements HelloWorldServer
func (s *server) SayHello(ctx context.Context, in *pb.HelloRequest) (*pb.HelloReply, error) {
	log.Printf("Received: %v", in.Name)
	return &pb.HelloReply{Message: "Hello " + in.Name}, nil
}

// GetUser
func (s *server) GetUser(ctx context.Context, in *pb.GetUserRequest) (*pb.User, error) {
	log.Printf("Received: %v", in.Id)
	return &pb.User{
		Id:   in.Id,
		Name: "SampleUser"}, nil
}

// CreateUser
func (s *server) CreateUser(ctx context.Context, in *pb.CreateUserRequest) (*pb.User, error) {
	log.Printf("Received: %v", in.Name)
	return &pb.User{
		Id:   "123",
		Name: in.Name}, nil
}

// --- for health check
type HealthServer struct{}

var version string

func (s *HealthServer) Check(ctx context.Context, in *health.DemoHealthCheckRequest) (*health.DemoHealthCheckResponse, error) {
	return &health.DemoHealthCheckResponse{Status: health.DemoHealthCheckResponse_SERVING, Version: version}, nil
}
func (s *HealthServer) Watch(in *health.DemoHealthCheckRequest, _ health.DemoHealth_WatchServer) error {
	// Example of how to register both methods but only implement the Check method.
	return status.Error(codes.Unimplemented, "unimplemented")
}

// ---

func main() {
	lis, err := net.Listen("tcp", port)
	if err != nil {
		log.Fatalf("failed to listen: %v", err)
	}
	s := grpc.NewServer()
	pb.RegisterHelloWorldServiceServer(s, &server{})
	// --- for health check
	health.RegisterDemoHealthServer(s, &HealthServer{})
	// ---
	if err := s.Serve(lis); err != nil {
		log.Fatalf("failed to serve: %v", err)
	}
}
