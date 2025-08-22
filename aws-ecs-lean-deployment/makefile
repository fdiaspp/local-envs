IMAGE_NAME:=...
IMAGE_TMP_OUTPUT:=/tmp/...
JOB_NAME:=..
CLUSTER_NAME:=..
SUBNETS=...,...,...
SECURITY_GROUP=...
AWS_REGION=us-west-2
LOG_GROUP:=/ecs/$(JOB_NAME)-service
ROLE_ARN:=...

authenticate:
	aws ecr get-login-password --region us-west-2 | docker login --username AWS --password-stdin ....dkr.ecr.us-west-2.amazonaws.com

build:
	@IMAGE_TAG=$(shell date +"%Y%m%d%H%M%S"); \
	IMAGE_URI=$(IMAGE_NAME):$$IMAGE_TAG; \
	eval "$$(ssh-agent -s)" > .ssh-agent-env && \
	ssh-add id_rsa; \
	DOCKER_BUILDKIT=1 docker build --ssh default \
	-t $$IMAGE_URI \
	. \
	--push && \
	echo $$IMAGE_URI > $(IMAGE_TMP_OUTPUT)	

deactivate-all-tasks-definitions:
	aws ecs list-task-definitions --family-prefix optic-$(JOB_NAME)-$1 --status ACTIVE \
	| jq -r '.taskDefinitionArns[]' \
	| while read -r TASK; do \
		aws ecs deregister-task-definition --task-definition "$$TASK" ; \
	done

create-task-definition:
	aws logs create-log-group --log-group-name "$(LOG_GROUP)" --region "$(AWS_REGION)" || true && \
	IMAGE_URI=$(shell cat $(IMAGE_TMP_OUTPUT)) \
	JOB_NAME=$(JOB_NAME) \
	LOG_GROUP=$(LOG_GROUP) \
	AWS_REGION=$(AWS_REGION) \
	ROLE_ARN=$(ROLE_ARN) \
	envsubst < task_definition.json > .task_definition.json && \
	aws ecs register-task-definition --cli-input-json file://.task_definition.json

create-service:
	aws ecs create-service \
	--cluster $(CLUSTER_NAME) \
	--service-name $(JOB_NAME)-service \
	--task-definition $(JOB_NAME)-task \
	--desired-count 1 \
	--launch-type FARGATE \
	--network-configuration "awsvpcConfiguration={subnets=[$(SUBNETS)],securityGroups=[$(SECURITY_GROUP)],assignPublicIp=DISABLED}"

update-service:
	aws ecs update-service \
	--cluster $(CLUSTER_NAME) \
	--service $(JOB_NAME)-service \
	--task-definition $(JOB_NAME)-task  \
	--force-new-deployment


deploy: build create-task-definition create-service

update: build deactivate-all-tasks-definitions create-task-definition update-service