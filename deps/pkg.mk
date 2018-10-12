## Pkg ##

$(SRCCACHE)/Pkg.jl-$(PKG_VER).tar.gz: | $(SRCCACHE)
	$(JLDOWNLOAD) $@ https://github.com/JuliaLang/Pkg.jl/archive/v$(PKG_VER).tar.gz

$(SRCCACHE)/Pkg.jl-$(PKG_VER)/source-extracted: $(SRCCACHE)/Pkg.jl-$(PKG_VER).tar.gz
	$(JLCHECKSUM) $<
	cd $(dir $<) && $(TAR) xzf $(notdir $<)
	echo 1 > $@

$(BUILDDIR)/Pkg.jl-$(PKG_VER)/build-compiled: $(SRCCACHE)/Pkg.jl-$(PKG_VER)/source-extracted
	cp -r $(SRCCACHE)/Pkg.jl-$(PKG_VER) $(BUILDDIR)
	echo 1 > $@

define PKG_INSTALL
	cp -r $1 $(JULIAHOME)/stdlib/Pkg
endef

$(eval $(call staged-install, \
	pkg,Pkg.jl-$(PKG_VER), \
	PKG_INSTALL,,,))

distclean-pkg:
	-rm -rf $(SRCCACHE)/Pkg.jl-$(PKG_VER).tar.gz $(SRCCACHE)/Pkg.jl-$(PKG_VER)
	-rm -rf $(BUILDDIR)/Pkg.jl-$(PKG_VER) $(JULIAHOME)/stdlib/Pkg

clean-pkg: distclean-pkg
get-pkg: $(SRCCACHE)/Pkg.jl-$(PKG_VER).tar.gz
extract-pkg: $(SRCCACHE)/Pkg.jl-$(PKG_VER)/source-extracted
configure-pkg: extract-pkg
compile-pkg: $(BUILDDIR)/Pkg.jl-$(PKG_VER)/build-compiled
fastcheck-pkg: #none
check-pkg: #none
