function __isElement(element) {
    return element instanceof Element || element instanceof HTMLDocument;  
  }
  
class ScopedEval {
  scope = {
    ondestroy : function() {},
    onreturn : function() {"* compiled *"}
  }

  error  = false
    
  constructor(scope, script) {
    
    this.script = new Function('exports', '{'+ script + '}');
  }
    
  eval() {
    try {
      return this.script(this.scope);
    } catch(err) {
      this.error = err;
    }
  }
} 

class ESMCell {
    scope = {}
    
    dispose() {
      this.scope.scope.ondestroy();
    }
    
    constructor(parent, data) {
      this.origin = parent;
      console.log('compiled ESM');
      console.log(data);
      this.scope = new ScopedEval({}, data)
      
      this.scope.eval();

      console.log(this.scope.scope);
      const result = this.scope.scope.onreturn();

      if (this.scope.error) {
        const errorDiv = document.createElement('div');
        errorDiv.innerText = this.scope.error;
        errorDiv.classList.add('err-js');
        this.origin.element.appendChild(errorDiv);
        return this;
      }

      if (__isElement(result)) {
        this.origin.element.appendChild(result);
        return this;
      }

      if (String(result) === 'undefined') {
        const om = document.createElement('span');
        om.innerText = "* compiled *";
        this.origin.element.appendChild(om);
        return this;
      } else {
      
        const editor = new window.EditorView({
          doc: String(result),
          extensions: [
            window.highlightSpecialChars(),
            window.EditorState.readOnly.of(true),
            window.javascript(),
            window.syntaxHighlighting(window.defaultHighlightStyle, { fallback: true }),
            window.editorCustomTheme
          ],
          parent: this.origin.element
        });    
    }
      
      return this;
    }
  }
  
  window.SupportedLanguages.push({
    check: (r) => {return(r[0] === '.esm')},
    plugins: [window.javascript()],
    name: window.javascriptLanguage.name
  });

  window.SupportedCells['esm'] = {
    view: ESMCell
  };