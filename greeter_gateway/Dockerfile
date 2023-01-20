# 一つ上の階層から -f で Dockerfileの場所を指定してbuildする
# docker build --no-cache -t greeter-gateway-image:v1 -f greeter_gateway/Dockerfile .

FROM golang:1.18-alpine3.16 as build

ENV APP_PATH /grpc-gateway-sample
WORKDIR $APP_PATH
COPY go.mod .
COPY go.sum .
WORKDIR $APP_PATH/pb
COPY pb .
# --- for health check
WORKDIR $APP_PATH/pb_health
COPY pb_health .
# ---
WORKDIR $APP_PATH/greeter_gateway
COPY greeter_gateway/main.go .

RUN apk update && apk add git

RUN go env -w GO111MODULE=off
RUN go get -u -v github.com/grpc-ecosystem/grpc-gateway/protoc-gen-grpc-gateway
#RUN go get -u -v github.com/grpc-ecosystem/grpc-gateway/protoc-gen-swagger
RUN go get -u -v github.com/golang/protobuf/protoc-gen-go
RUN go env -w GO111MODULE=on

RUN go mod tidy

EXPOSE 15000
ENV GRPC_GATEWAY_ENDPOINT greeter-server:5001
CMD go run main.go