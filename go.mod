module grpc-gateway-sample

go 1.18

replace local.packages/pb => ./pb

// --- for health check
replace local.packages/pb_health => ./pb_health

// ---

require (
	github.com/golang/glog v1.0.0
	github.com/grpc-ecosystem/grpc-gateway/v2 v2.14.0
	golang.org/x/net v0.2.0
	google.golang.org/grpc v1.51.0
	local.packages/pb v0.0.0-00010101000000-000000000000
	local.packages/pb_health v0.0.0-00010101000000-000000000000
)

require (
	github.com/golang/protobuf v1.5.2 // indirect
	golang.org/x/sys v0.2.0 // indirect
	golang.org/x/text v0.4.0 // indirect
	google.golang.org/genproto v0.0.0-20221114212237-e4508ebdbee1 // indirect
	google.golang.org/protobuf v1.28.1 // indirect
)
