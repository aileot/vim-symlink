PIP ?= pip3
VIM ?= vim
VINT ?= vint
VIM_FLAGS ?= --clean -u vimrc
ifeq ($(VIM),vim)
	VIM_FLAGS += -N -Es
else ifeq ($(VIM),nvim)
	VIM_FLAGS += --headless
endif

.PHONY: all
all: install lint test

.PHONY: install
install:
	git submodule update --init
	$(PIP) install vim-vint==0.3.21

.PHONY: lint
lint:
	$(VINT) plugin

.PHONY: test
test:
	@cd test && $(VIM) $(VIM_FLAGS)                                      -c 'Vader! symlink.vader'
	@cd test && $(VIM) $(VIM_FLAGS) -R                                   -c 'Vader! symlink.vader'
	@cd test && $(VIM) $(VIM_FLAGS) -o fixture/foo.link fixture/bar.link -c 'Vader! symlink-split-horizontal.vader'
	@cd test && $(VIM) $(VIM_FLAGS) -O fixture/foo.link fixture/bar.link -c 'Vader! symlink-split-vertical.vader'
	@cd test && $(VIM) $(VIM_FLAGS) -d fixture/foo.link fixture/bar.link -c 'Vader! symlink-split-vertical.vader'
