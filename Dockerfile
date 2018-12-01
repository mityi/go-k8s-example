FROM golang:1.11

ENV RELEASE 0.0.1

# add a non-privileged user 
RUN useradd -u 10001 myapp

RUN mkdir -p /go/src/github.com/mityi/go-k8s-simple
ADD . /go/src/github.com/mityi/go-k8s-simple
WORKDIR /go/src/github.com/mityi/go-k8s-simple

# build the binary with go build

RUN CGO_ENABLED=0 go build \
	-ldflags "-s -w -X github.com/mityi/go-k8s-simple/internal/version.Version=${RELEASE}" \
	-o bin/go-k8s-api github.com/mityi/go-k8s-simple/cmd/go-k8s-api
# Stage 2. Run the binary
FROM scratch

ENV PORT 8080
ENV DIAG_PORT 8585

COPY --from=0 /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/

COPY --from=0 /etc/passwd /etc/passwd
USER myapp

COPY --from=0 /go/src/github.com/mityi/go-k8s-simple/bin/go-k8s-api /go-k8s-api
EXPOSE $PORT
EXPOSE $DIAG_PORT

CMD ["/go-k8s-api"]