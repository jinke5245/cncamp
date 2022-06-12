FROM golang:alpine as build
ENV LANG C.UTF-8

RUN apk update
RUN apk add --no-cache git make

RUN go env -w GOPROXY=https://goproxy.cn,direct

COPY . /project
WORKDIR /project
RUN make clean && make build


FROM alpine:latest
COPY --from=build /project/bin/httpserver /bin/httpserver
ENTRYPOINT ["/bin/httpserver"]
