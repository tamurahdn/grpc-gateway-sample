run:
	protoc -I/usr/local/include -I. \
	-I${GOPATH}/src \
	-I${GOPATH}/src/github.com/googleapis/googleapis \
	--go_out=plugins=grpc:. \
	proto/service.proto; \
	protoc -I/usr/local/include -I. \
	-I${GOPATH}/src \
	-I${GOPATH}/src/github.com/googleapis/googleapis \
	--grpc-gateway_out=logtostderr=true:. \
	proto/service.proto; \
	protoc -I/usr/local/include -I. \
	-I${GOPATH}/src \
	-I${GOPATH}/src/github.com/googleapis/googleapis \
	--go_out=plugins=grpc:. \
	proto/health.proto; \
	protoc -I/usr/local/include -I. \
	-I${GOPATH}/src \
	-I${GOPATH}/src/github.com/googleapis/googleapis \
	--grpc-gateway_out=logtostderr=true:. \
	proto/health.proto;