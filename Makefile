# Basic go commands
GOCMD=go
GOBUILD=$(GOCMD) build
GOCLEAN=$(GOCMD) clean
GOTEST=$(GOCMD) test
GOGET=$(GOCMD) get
GOMOD=$(GOCMD) mod
GORUN=$(GOCMD) run

# Binary names
APP_NAME=hercules
APP_VERSION=V1.0.3
ARGS=argsparam
HIDE_ARGS=hideargsparam
OUTDIR=./bin
BINARY_NAME_LINUX=$(OUTDIR)/${APP_NAME}
BINARY_NAME_WIN=$(OUTDIR)/${APP_NAME}.exe

# ldflags
PARAM_LDFLAGS="-X 'github.com/illidaris/assembly.CommitID=$(shell git log -1 --pretty=format:"%H")'\
-X 'github.com/illidaris/assembly.Name=${APP_NAME}'\
-X 'github.com/illidaris/assembly.Version=${APP_VERSION}'\
-X 'github.com/illidaris/assembly.CommitAuthor=$(shell git log -1 --pretty=format:"%an")'\
-X 'github.com/illidaris/assembly.CommitTime=$(shell git log -1 --pretty=format:"%cd" --date=iso)'\
-X 'github.com/illidaris/assembly.BuildTime=$(shell date +%s)'\
-X 'github.com/illidaris/assembly.Args=${ARGS}'\
-X 'github.com/illidaris/assembly.HideArgs=${HIDE_ARGS}'\
-X 'github.com/illidaris/assembly.BuildNumber=${BUILD_NUMBER}'\
-X 'github.com/illidaris/assembly.BuildJob=${JOB_NAME}'"

# linux
build:
	CGO_ENABLED=0 GOOS=linux GOARCH=amd64 $(GOBUILD) -ldflags $(PARAM_LDFLAGS) -o $(BINARY_NAME_LINUX) -v

# linux
build2linux:
	CGO_ENABLED=0 GOOS=linux GOARCH=amd64 $(GOBUILD) -ldflags $(PARAM_LDFLAGS) -gcflags "all=-N -l" -o $(BINARY_NAME_LINUX) -v

windows:
	$(GOMOD) tidy
	$(GOBUILD) -o $(BINARY_NAME_WIN) -v

test:
	go test ./... -gcflags=all=-l -cover
	go vet ./...

test2file:
	go test ./... -v -gcflags=all=-l -json > test.json
	go test ./... -gcflags=all=-l -coverprofile=covprofile
	go vet -json ./... 2> vet_report.out

package:
	go mod tidy
	go generate ./...

init:
	go mod tidy
	go generate ./...

clean:
	rm -rf ./bin