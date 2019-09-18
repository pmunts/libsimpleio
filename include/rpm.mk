# gmake rule for building an RPM package

# Copyright (C)2019, Philip Munts, President, Munts AM Corp.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# * Redistributions of source code must retain the above copyright notice,
#   this list of conditions and the following disclaimer.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.

BUILDARCH	?= noarch
GROUP		?= Applications
LICENSE		?= Unknown

# Define a pattern rule for building RPM packages

%.rpm: %
	cp $(LIBSIMPLEIO)/include/specfile.template specfile
	sed -i 's/@@NAME@@/$(PKGNAME)/g' specfile
	sed -i 's/@@SUMMARY@@/$(PKGNAME)/g' specfile
	sed -i 's/@@VERSION@@/$(PKGVERSION)/g' specfile
	sed -i 's/@@BUILDARCH@@/$(BUILDARCH)/g' specfile
	sed -i 's/@@GROUP@@/$(GROUP)/g' specfile
	sed -i 's/@@LICENSE@@/$(LICENSE)/g' specfile
	cd $? && find * -type d -exec echo "%dir /{}" ";" | grep -v DEBIAN >>../specfile
	cd $? && find * -type f -exec echo "/{}" ";" | grep -v DEBIAN >>../specfile
	rpmbuild --buildroot=`pwd`/$? --define="_topdir `pwd`/rpmbuild" -bb specfile
	cp rpmbuild/RPMS/*/*.rpm .
