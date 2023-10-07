# WLJS ESM modules support package
**An extension for [WLJS-Editor](https://github.com/JerryI/wljs-editor) to add JS type of cells with ESbuild bundler**

*requires NodeJS to be installed on your pc*

An example with confetti package

*cell 1*
```mathematica
NPM["js-confetti"] // Install 
```

*cell 2*
```js
.esm

import JSConfetti from 'js-confetti'
const jsConfetti = new JSConfetti()
jsConfetti.addConfetti();

const re = document.createElement('span');
re.innerText = "everything is fine!";

this.onreturn = () => {
  return re;
}
```

## Only for OSX users
There is a bug in Mathematica, that `PATH` variable differs from your terminal in OS (see an [issue](https://mathematica.stackexchange.com/questions/99704/why-does-mathematica-use-a-different-path-than-terminal)).

__How to fix__
Open your terminal app
```bash
echo $PATH
```
and then copy the content to a new cell in the notebook
```mathematica
SetEnvironment["PATH" -> "<your path variable>"]
```

After that it will work properly.

## License
Project is released under the GNU General Public License (GPL).
