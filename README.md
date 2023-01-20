## はじめに

下記サイトを参考にしています。

https://qiita.com/ryu3/items/b2882d4f45c7f8485030

また、Health Check部分は下記を参考にしています。

https://qiita.com/gold-kou/items/63befd8c6d50dcc5c2eb

あと、ALB + ECS で動くようにしました。

IaC は Terraform、CI/CD は GitHub Actions です。

## 注意
下記が必要です。
```
$ go env -w GO111MODULE=off # Go Modules の OFF

$ go get -u -v github.com/googleapis/googleapis # protoc で必要

$ go get -u -v github.com/grpc-ecosystem/grpc-gateway/protoc-gen-grpc-gateway
$ # go get -u -v github.com/grpc-ecosystem/grpc-gateway/protoc-gen-swagger # 使っていない
$ go get -u -v github.com/golang/protobuf/protoc-gen-go

$ go env -w GO111MODULE=on # Go Modules の ON（復旧）
$ go mod tidy
```

## 使い方(Local版)
参考にしたサイトと一緒です。(ポート番号だけ元サイトから変更しています)

下記を別々のターミナルで実行します。

```
$ go run greeter_server/main.go #serverの起動
```
```
$ go run greeter_gateway/main.go #gatewayの起動
```

## 使い方(Docker版)
Dockerイメージ を build してから実行します。

こちらも別々のターミナルで実行します。

```
$ docker build --no-cache -t greeter-server-image:v1 -f greeter_server/Dockerfile --build-arg DEMO_VERSION="v1.0.1". #serverのDockerイメージビルド

$ docker run -p 5001:5001 --name greeter-server --rm greeter-server-image:v1 #serverの起動
```

※ DEMO _VERSIONに指定した文字列は、health checkのresponseに出力されます

```
$ docker build --no-cache -t greeter-gateway-image:v1 -f greeter_gateway/Dockerfile . #gatewayのDockerイメージビルド

$ docker run -p 15000:15000 --name greeter-gateway --rm --link greeter-server greeter-gateway-image:v1 #gatewayの起動
```

## 動作確認
Local版とDocker版で共通です。

```
$ curl -X GET http://localhost:15000/v1/example/sayhello/nakata

{"message":"Hello nakata"}

$ curl -X GET http://localhost:15000/v1/example/users/10

{"id":"10","name":"SampleUser"}

$ curl -X POST http://localhost:15000/v1/example/users -d '{"name":"nakata"}'

{"id":"123","name":"nakata"}

$ curl -X GET http://localhost:15000/grpc/health

{"status":"SERVING", "version":"v1.0.1"}
```


## その他
proto/service.proto を変更した場合のprotocコマンドは下記の通りです。

```
$ protoc -I/usr/local/include -I. \
  -I$GOPATH/src \
  -I$GOPATH/src/github.com/googleapis/googleapis \
  --go_out=plugins=grpc:. \
  proto/service.proto # gRPC stub側
```
```
$ protoc -I/usr/local/include -I. \
  -I$GOPATH/src \
  -I$GOPATH/src/github.com/googleapis/googleapis \
  --grpc-gateway_out=logtostderr=true:. \
  proto/service.proto # reverse-proxy側
```

proto/health.proto を変更した場合のprotocコマンドは下記の通りです。

```
protoc -I/usr/local/include -I. \
  -I$GOPATH/src \
  -I$GOPATH/src/github.com/googleapis/googleapis \
  --go_out=plugins=grpc:. \
  proto/health.proto # health check の gRPC stub側
```
```
protoc -I/usr/local/include -I. \
  -I$GOPATH/src \
  -I$GOPATH/src/github.com/googleapis/googleapis \
  --grpc-gateway_out=logtostderr=true:. \
  proto/health.proto # reverse-proxy の gRPC stub側
```

なお、現在は下記でまとめて実行できます。
```
make
```
