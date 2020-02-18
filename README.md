# latex-lexend

The [Lexend fonts](https://www.lexend.com/) for XeLaTeX and LuaLaTeX through fontspec

<!-- TOC depthFrom:2 depthTo:6 withLinks:1 updateOnSave:1 orderedList:0 -->

- [Dowloading](#dowloading)
- [Working with the Source Code](#working-with-the-source-code)
	- [Cloning](#cloning)
	- [Building](#building)
		- [Prerequisites](#prerequisites)
		- [Making the Package](#making-the-package)
	- [Developing](#developing)
- [License](#license)
- [Random Quote](#random-quote)

<!-- /TOC -->

## Dowloading

You can find this package on [CTAN](https://ctan.org/): https://ctan.org/pkg/lexend

## Working with the Source Code

### Cloning

To clone this repo, be sure to clone it recursively:

```sh
git clone --recursive https://github.com/BrainStone/latex-lexend.git
```

For older git versions or if you forgot to clone it recursively, do it like this:

```sh
git clone https://github.com/BrainStone/latex-lexend.git
cd latex-lexend
git submodule update --init --recursive
```

### Building

#### Prerequisites

Before you try to build this package make sure you have the following installed:

- `make`
- `pandoc`
- A working TeX environment with a working `latexmk` and `lualatex` command.
- `git` (Yes, `git` is used to determine the version number automatically. So if you want it build properly, you need it, if you don't care about that, it's
  not needed)

#### Making the Package

Now if you just want to build the package, run:

```sh
make
```

Removing the build directory after creating the package can be done with

```sh
make clean
```

### Developing

If you wish to work on this package, be sure to clone it as described and also to run this command to set everything up:

```sh
make setupWorkspace
```

## License

The licensing of this project is a bit uncommon, so let me explain:

The source repository, the one you find under https://github.com/BrainStone/latex-lexend, however is licensed under the
[GNU General Public License v3.0](https://www.gnu.org/licenses/gpl-3.0.html).

The final package, the one you find on [CTAN](https://ctan.org/), is licensed under [The LaTeX Project Public License 1.3c](https://ctan.org/license/lppl1.3c).
So use it like you would use most other packages on [CTAN](https://ctan.org/).

Lastly, the font collection itself is licensed under the [SIL Open Font License 1.1](https://opensource.org/licenses/OFL-1.1). You can find the license file
under https://github.com/ThomasJockin/lexend/blob/master/OFL.txt.

## Random Quote

> Hardware: The parts of a computer system that can be kicked.
>
> — <cite>Jeff Pesis</cite>
