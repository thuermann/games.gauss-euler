#
# $Id: Makefile,v 1.1 2017/08/06 11:43:19 urs Exp $
#

RM       = rm -f
programs = gauss-euler
output   = [1-5]-*

.PHONY: all
all: $(programs)

.PHONY: clean
clean:
	$(RM) $(programs) $(output)
