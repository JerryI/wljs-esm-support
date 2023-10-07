# WLJS JS support package
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

## License
Project is released under the GNU General Public License (GPL).