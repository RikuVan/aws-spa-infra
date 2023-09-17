import {Router} from './router.js'
import {replaceHTML, appendHTML, toParam} from './helpers.js'
import {dogs} from './dogs.js '

const App = {
  nav: document.querySelector('nav'),
  content: document.getElementById('page-content'),
  renderNav: () => {
    appendHTML(
      App.nav,
      dogs.map(dog => `<li><a href="/${toParam(dog.name)}">${dog.name}</a></li>`).join('')
    );
  },
  init: () => {
    let router = new Router();
    router
      .on('/', () => {
        replaceHTML(
          App.content,
          `<h1>Welcome to the dogs page!</h1>`
        );
      })
      dogs.map(dog => {
        router.on(`/${toParam(dog.name)}`, () => {
          replaceHTML(
            App.content,
            `
            <h1>${dog.name}</h1>
              <img src="${dog.src}"></img>
            </div>
          `
          );
        })
      })
      router.on('*', () => {
        replaceHTML(
          App.content,
          `
          <h1>Not found</h1>
            <a href="/">Go to home</a>
          </div>
        `
        );
      });

    router.listen();
    App.renderNav();
  }
}


App.init();