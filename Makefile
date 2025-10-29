VIM ?= vim
VIM_FLAGS ?= --clean -u vimrc
ifeq ($(notdir $(VIM)),vim)
	VIM_FLAGS += -N -Es
else ifeq ($(notdir $(VIM)),nvim)
	VIM_FLAGS += --headless
endif

test/vader.vim:
	git clone https://github.com/junegunn/vader.vim.git test/vader.vim

.PHONY: clean
clean:
	rm -rf test/vader.vim

.PHONY: test
test: test/vader.vim
	@cd test && $(VIM) $(VIM_FLAGS)                                      -c 'Vader! symlink.vader'
	@cd test && $(VIM) $(VIM_FLAGS) -R                                   -c 'Vader! symlink.vader'
	@cd test && $(VIM) $(VIM_FLAGS)                                      -c 'Vader! symlink-edit-in-popup.vader'
	@cd test && $(VIM) $(VIM_FLAGS) -o fixture/foo.link fixture/bar.link -c 'Vader! symlink-split-horizontal.vader'
	@cd test && $(VIM) $(VIM_FLAGS) -O fixture/foo.link fixture/bar.link -c 'Vader! symlink-split-vertical.vader'
	@cd test && $(VIM) $(VIM_FLAGS) -d fixture/foo.link fixture/bar.link -c 'Vader! symlink-split-vertical.vader'
	@cd test && $(VIM) $(VIM_FLAGS) \
		--cmd 'autocmd! BufReadPre foo.link let b:symlink_should_resolve_path = 0' \
		--cmd 'autocmd! BufReadPre bar.link let b:symlink_should_resolve_path = 1' \
		-o fixture/foo.link fixture/bar.link \
		-c 'Vader! options.vader'
