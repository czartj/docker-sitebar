default: docker_build

docker_build:
	@docker build -t czartj/docker-sitebar:latest --build-arg VCS_REF=`git rev-parse --short HEAD` --build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` .
