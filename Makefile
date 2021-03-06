RELEASE ?= 0

ifeq ($(RELEASE),1)
	PROFILE ?= release
	CARGO_ARGS = --release
else
	PROFILE ?= debug
	CARGO_ARGS =
endif

.PHONY: all
all:
	cargo build ${CARGO_ARGS}

.PHONY: install
install: install-bin install-systemd

.PHONY: install-bin
install-bin: all
	install -D -t ${DESTDIR}/usr/bin target/${PROFILE}/coreos-installer

.PHONY: install-systemd
install-systemd: all
	install -D -m 644 -t $(DESTDIR)/usr/lib/systemd/system systemd/*.{service,target}
	install -D -t $(DESTDIR)/usr/lib/systemd/system-generators systemd/coreos-installer-generator
	install -D -t $(DESTDIR)/usr/libexec systemd/coreos-installer-service
