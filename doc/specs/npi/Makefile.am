## vim: ft=automake comments=b\:#,b\:##,b\:#\! formatoptions+=tcqlor
## =============================================================================
## 
# @(#) File: doc/specs/npi/Makefile.am  Version: @VERSION@  Date: @PACKAGE_DATE@
##
## -----------------------------------------------------------------------------
##
## Copyright (c) 2008-2015  Monavacon Limited <http://www.monavacon.com/>
## Copyright (c) 2001-2008  OpenSS7 Corporation <http://www.openss7.com/>
## Copyright (c) 1997-2001  Brian F. G. Bidulock <bidulock@openss7.org>
##
## All Rights Reserved.
##
## This program is free software; you can redistribute it and/or modify it under
## the terms of the GNU Affero General Public License as published by the Free
## Software Foundation; version 3 of the License.
##
## This program is distributed in the hope that it will be useful, but WITHOUT
## ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
## FOR A PARTICULAR PURPOSE.  See the GNU Affero General Public License for more
## details.
##
## You should have received a copy of the GNU Affero General Public License
## along with this program.  If not, see <http://www.gnu.org/licenses/>, or
## write to the Free Software Foundation, Inc., 675 Mass Ave, Cambridge, MA
## 02139, USA.
##
## -----------------------------------------------------------------------------
##
## U.S. GOVERNMENT RESTRICTED RIGHTS.  If you are licensing this Software on
## behalf of the U.S. Government ("Government"), the following provisions apply
## to you.  If the Software is supplied by the Department of Defense ("DoD"), it
## is classified as "Commercial Computer Software" under paragraph 252.227-7014
## of the DoD Supplement to the Federal Acquisition Regulations ("DFARS") (or any
## successor regulations) and the Government is acquiring only the license rights
## granted herein (the license rights customarily provided to non-Government
## users).  If the Software is supplied to any unit or agency of the Government
## other than DoD, it is classified as "Restricted Computer Software" and the
## Government's rights in the Software are defined in paragraph 52.227-19 of the
## Federal Acquisition Regulations ("FAR") (or any successor regulations) or, in
## the cases of NASA, in paragraph 18.52.227-86 of the NASA Supplement to the FAR
## (or any successor regulations).
##
## -----------------------------------------------------------------------------
##
## Commercial licensing and support of this software is available from OpenSS7
## Corporation at a fee.  See http://www.openss7.com/
##
## =============================================================================

include ../../../am/openss7.am

info_TEXINFOS		=

if DEVELOPMENT
## DEVELOPMENT

info_TEXINFOS		+= npi.texi npi_mtp.texi npi_sccp.texi

npi.h: $(top_srcdir)/src/include/sys/npi.h
	$(AM_V_GEN)cat $< | sed -e '1,/\*\//d;/doxygen/d;/#ident/d;/^\/\/\//d' | cat -s | expand > $@

CLEANFILES += npi.h

npi_TEXINFOS		= \
			  npi.h \
			  $(top_srcdir)/scripts/texi/macros.texi \
			  $(top_srcdir)/scripts/texi/versions.texi

npi_mtp.h: $(top_srcdir)/src/include/sys/npi_mtp.h
	$(AM_V_GEN)cat $< | sed -e '1,/\*\//d;/doxygen/d;/#ident/d;/^\/\/\//d' | cat -s | expand > $@

CLEANFILES += npi_mtp.h

npi_mtp_TEXINFOS	= \
			  npi_mtp.h \
			  $(top_srcdir)/scripts/texi/macros.texi \
			  $(top_srcdir)/scripts/texi/versions.texi

npi_sccp.h: $(top_srcdir)/src/include/sys/npi_sccp.h
	$(AM_V_GEN)cat $< | sed -e '1,/\*\//d;/doxygen/d;/#ident/d;/^\/\/\//d' | cat -s | expand > $@

CLEANFILES += npi_sccp.h

npi_sccp_TEXINFOS	= \
			  npi_sccp.h \
			  $(top_srcdir)/scripts/texi/macros.texi \
			  $(top_srcdir)/scripts/texi/versions.texi

if MAINTAINER_MODE
if AMDEP
npi_TEXINFOS		+= \
			  $(top_builddir)/scripts/texi/args.texi
npi_mtp_TEXINFOS	+= \
			  $(top_builddir)/scripts/texi/args.texi
npi_sccp_TEXINFOS	+= \
			  $(top_builddir)/scripts/texi/args.texi
endif
endif

EXTRA_info_TEXINFOS	= \
			  $(top_builddir)/scripts/texi/args.texi \
			  $(info_TEXINFOS) \
			  $(npi_TEXINFOS)

if PKG_BUILD_INDEP
## PKG_BUILD_INDEP

FIG_FIGS		= \
			npi_fig1.fig \
			npi_fig2.fig \
			npi_fig3.fig \
			npi_fig4.fig \
			npi_fig5.fig \
			npi_fig6.fig \
			npi_fig7.fig \
			npi_fig8.fig \
			npi_fig9.fig \
			npi_fi10.fig \
			npi_fi11.fig \
			npi_fi12.fig \
			npi_fi13.fig \
			npi_fi14.fig \
			npi_fi15.fig \
			npi_fi16.fig \
			npi_fi17.fig \
			npi_fi18.fig \
			npi_fi19.fig \
			npi_fi20.fig \
			npi_fi21.fig \
			npi_fi22.fig \
			npi_fi23.fig

TBL_TBLS		= \
			npi_mtp_taba1.tbl \
			npi_sccp_taba1.tbl \
			npi_sccp_taba2.tbl \
			npi_sccp_taba3.tbl \
			npi_sccp_taba4.tbl \
			npi_sccp_taba5b.tbl \
			npi_sccp_taba5.tbl \
			npi_sccp_taba6.tbl \
			npi_sccp_taba7.tbl \
			npi_tab1.tbl \
			npi_tab2.tbl \
			npi_tab3.tbl \
			npi_tab4.tbl \
			npi_tab5.tbl \
			npi_tab6.tbl \
			npi_tab7.tbl \
			npi_tab8.tbl \
			npi_taba1.tbl \
			npi_tabb1.tbl \
			npi_tabb2.tbl \
			npi_tabb3.tbl \
			npi_tabb4.tbl \
			npi_tabb5.tbl \
			npi_tabb6.tbl \
			npi_tabb7.tbl \
			npi_tabb8.tbl \
			npi_tabc1.tbl \
			npi_tabc2.tbl

## PKG_BUILD_INDEP
endif

## DEVELOPMENT
endif

include ../../../am/info.am

## =============================================================================
## vim: ft=automake comments=b\:#,b\:##,b\:#\! formatoptions+=tcqlor
