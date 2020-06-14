.DEFAULT_GOAL := deploy

export PLATFORM_NAME  ?= dev
export BASE_DOMAIN    ?= cloud-account-name.superhub.io
export DOMAIN_NAME    ?= $(PLATFORM_NAME).$(BASE_DOMAIN)

STATE_BUCKET ?= agilestacks.cloud-account-name.superhub.io
STATE_REGION ?= us-east-2

STACK_NAME ?= platform

ELABORATE_FILE_FS := .hub/$(DOMAIN_NAME).yaml.elaborate
ELABORATE_FILE_S3 := s3://$(STATE_BUCKET)/$(DOMAIN_NAME)/hub/$(STACK_NAME)/hub.elaborate
ELABORATE_FILES   := $(ELABORATE_FILE_FS),$(ELABORATE_FILE_S3)
STATE_FILE_FS     := .hub/$(DOMAIN_NAME).yaml.state
STATE_FILE_S3     := s3://$(STATE_BUCKET)/$(DOMAIN_NAME)/hub/$(STACK_NAME)/hub.state
STATE_FILES       := $(STATE_FILE_FS),$(STATE_FILE_S3)
COMPONENT_OFFSET  := $(if $(OFFSET),-o $(OFFSET),)
COMPONENT_LIST := $(if $(COMPONENT),-c $(COMPONENT),)

COMPONENT :=
VERB :=

HUB_OPTS ?=

hub ?= hub -d --aws_region $(STATE_REGION)
aws ?= aws --region $(STATE_REGION)

ifdef HUB_TOKEN
ifdef HUB_ENVIRONMENT
ifdef HUB_STACK_INSTANCE
HUB_LIFECYCLE_OPTS ?= --hub-environment "$(HUB_ENVIRONMENT)" --hub-stack-instance "$(HUB_STACK_INSTANCE)" \
	--hub-sync --hub-sync-skip-parameters-and-oplog
endif
endif
endif

$(ELABORATE_FILE_FS): hub.yaml params.yaml
	$(hub) elaborate \
		hub.yaml params.yaml \
		$(HUB_OPTS) \
		-o $(ELABORATE_FILES)

elaborate:
	-rm -f $(ELABORATE_FILE_FS)
	$(MAKE) $(ELABORATE_FILE_FS)
.PHONY: elaborate

pull:
	$(hub) pull hub.yaml
.PHONY: pull

explain:
	$(hub) explain $(ELABORATE_FILES) $(STATE_FILES) $(HUB_OPTS) --color -r | less -R
.PHONY: explain

deploy: $(ELABORATE_FILE_FS)
	$(hub) deploy $(ELABORATE_FILES) -s $(STATE_FILES) $(HUB_LIFECYCLE_OPTS) $(HUB_OPTS) \
		$(COMPONENT_LIST) $(COMPONENT_OFFSET)
.PHONY: deploy

undeploy: $(ELABORATE_FILE_FS)
	$(hub) --force undeploy $(ELABORATE_FILES) -s $(STATE_FILES) $(HUB_LIFECYCLE_OPTS) $(HUB_OPTS) \
		$(COMPONENT_LIST) $(COMPONENT_OFFSET)
.PHONY: undeploy
