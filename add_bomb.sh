#!/bin/sh

export GOPROXY=https://goproxy.io,direct
mkdir bombardier_tmp
cd bombardier_tmp
go mod init bombardier_tmp
go mod edit -replace github.com/codesenberg/bombardier=github.com/PXEiYyMH8F/bombardier@78-add-proxy-support
go get github.com/codesenberg/bombardier
go build -o bombardier github.com/codesenberg/bombardier
mkdir -p ~/go/bin/
mv bombardier ~/go/bin/
cd ..
rm -rf bombardier_tmp
