# filename: Makefile
# author: Hwa
# version: 0.1
# history: 
#	0.1  添加lex、syn、syn-c、parser、clean 目标
#	0.2  添加test目标
#	0.3  添加scanner目标
#	0.4  delete scanner target
#	0.5  增加了test
#   0.6  update test target
#   0.7  add test one file in test target

# 编译器设定和编译选项
CC = gcc -g
FLEX = flex
BISON = bison
CFLAGS = -std=c99

# 编译目标
CFILES = $(shell find ./ -name "*.c")
OBJS = $(CFILES:.c=.o)
LFILE = $(shell find ./ -name "*.l")
YFILE = $(shell find ./ -name "*.y")
LFC = $(shell find ./ -name "*.l" | sed s/[^/]*\\.l/lex.yy.c/)
YFC = $(shell find ./ -name "*.y" | sed s/[^/]*\\.y/syntax.tab.c/)
LFO = $(LFC:.c=.o)
YFO = $(YFC:.c=.o)


parser: syn $(filter-out $(LFO),$(OBJS))
	$(CC) -o parser $(filter-out $(LFO),$(OBJS)) -lfl 

syn: lex syn-c
	$(CC) -c $(YFC) -o $(YFO)

lex: $(LFILE)
	$(FLEX) -o $(LFC) $(LFILE)

syn-c: $(YFILE)
	$(BISON) -o $(YFC) -d -v $(YFILE)

-include $(patsubst %.o, %.d, $(OBJS))

.PHONY: clean test
test: 
	# only test one file
	# ./parser ../tests/test3.txt

	# test all the files in folder ../tests/
	for file in ../tests/*; \
	do \
		if test -f $$file; \
		then \
			echo "-------------------------"; \
			echo $$file; \
			./parser $$file; \
			echo; \
		fi \
	done

clean: 
	rm -f parser lex.yy.c syntax.tab.c syntax.tab.h syntax.output
	rm -f $(OBJS) $(OBJS:.o=.d)
	rm -f $(LFC) $(YFC) $(YFC:.c=.h)
	rm -f *~


