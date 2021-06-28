<h1 align="center">LE-compiler</h1>

<p align="center">Compiler front end of logical expression evaluation, course project of CP.</p>

# Feature
+ logical expression evaluation
+ count skipped comparisons caused by short circuit
+ arithmetic operations support
+ support CLI test and test file tests
+ fundamental error prompt

# Build
First of all, you need to meet the following **prerequisites** before the building:
- **gcc**: C is selected as the target programming language, so any compiler of C that supports C99 is applicable.
- **make**: make is used as the build tool.
- **flex**: flex is needed to do the lexical analysis.
- **bison**: bison is selected to do the syntax and semantic analysis.

Fortunately, you can install all the tools above with only one command on Ubuntu/Debian with priviledge:
```shell
sudo apt-get install gcc make flex bison --yes
```
or this command on CentOS:
```shell
sudo yum -y install gcc make flex bison 
```


To build, first you need to clone the project to local:
```
git clone https://github.com/HwaHe/LE-compiler.git
```

Then cd into the project's source code directory and build the parser with `make`:

```shell
cd src
make
```

And now you have successfully built my LE-compiler tool :bouquet:!

You can test it in terminal:
```shell
./parser
```
or use `make` to do the prepared test:
```shell
make test
```

Have fun:wink:~

# TODO
- [x] add support for octal integer and hex integer
- [x] add support for octal integer and hex integer of wrong format
- [ ] add support for recovery from lex error
- [ ] add support for recovery from syntax error

If time permitted, I'll dive into `flex&bison` to complete the todos.

# License
[Apache License](LICENSE)

<center>Copyright © 2021 Hwa</center>

---
<p align="center"><b>If you like my project, feel free to give my repo a star~ :star: :arrow_up:. </b></p>
