.PHONY: version doctor

PANA_SCRIPT = ./tool/verify_pub_score.sh 100
VALIDATE_SCRIPT = ./tool/validate-formatting.sh
BUMPV_VERSION_SCRIPT = ./tool/bump-version.sh

EXAMPLE_PATH = example

FVM = fvm
FVM_FLUTTER = $(FVM) flutter
DART = dart
FVM_DART = $(FVM) ${DART}


init:
	make activate_fvm; $(FVM) use 3.24.3 --force; $(FVM_DART) pub global activate pana;

activate_fvm:
	${DART} pub global activate ${FVM}

version:
	$(FVM_FLUTTER) --version; $(FVM_DART) --version;

doctor:
	$(FVM_FLUTTER) doctor;

ifeq (bump, $(firstword $(MAKECMDGOALS)))
  runargs := $(wordlist 2, $(words $(MAKECMDGOALS)), $(MAKECMDGOALS))
  $(eval $(runargs):;@true)
endif
bump:
	./tool/bump-version.sh $(filter-out $@,$(MAKECMDGOALS))

pub_get:
	$(FVM_FLUTTER) packages get;

clean:
	$(FVM_FLUTTER) clean;

fix:
	$(FVM_DART) format .;

analyze:
	$(FVM_FLUTTER) analyze . --fatal-infos;

pana:
	$(PANA_SCRIPT);

validate:
	$(VALIDATE_SCRIPT)