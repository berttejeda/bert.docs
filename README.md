Interactive HTA Documents
===================

# Why?

I needed a means of producing documents that could better engage the reader and perform some advanced actions such as interacting with the system.

This is where good ol' MSHTA comes in. 

TODO 

MORE DOCUMENTATION TO COME

# Features

TODO

MORE DOCUMENTATION TO COME

# Requirements

**python 2.7+**
[pandoc](https://pandoc.org/installing.html)
[pp](https://github.com/CDSoft/pp) (Precompiled binaries available for Windows and Linux)
[cmder][http://cmder.net/](optional, full version is best as it ships with git-bash)

# How to use

I've created a wrapper script that simplifies usage:

```bash
./build.sh -s _template/default.markdown,_template/includes/*.md -o default.hta -t _template/templates/default.html
```

```bash
./build.sh -s _template/default.markdown,_template/includes/*.md -o default.hta -t _template/templates/default.html --dry
```

The above `--dry` run will print out:

```bash
pp _template/default.markdown _template/includes/*.md  | pandoc -o 'default.hta' -c '_common/templates/default.css' -H '_common/templates/header.html' --template _template/templates/default.html --self-contained
--standalone
```

TODO

MORE DOCUMENTATION TO COME

# Credits

[BlackrockDigital/startbootstrap-simple-sidebar](https://github.com/BlackrockDigital/startbootstrap-simple-sidebar): An off canvas sidebar navigation Bootstrap HTML template created by Start Bootstrap

http://stackoverflow.com
