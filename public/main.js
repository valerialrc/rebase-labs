const fragment = new DocumentFragment();
const url = 'http://localhost:3000/tests';

fetch(url).
  then((response) => response.json()).
  then((data) => {
    const uniqueTokens = new Set(data.map(test => test.result_token));

    uniqueTokens.forEach(token => {
      const li = document.createElement('li');
      const link = document.createElement('a');
      link.textContent = token;
      link.href = `http://localhost:3000/tests/${token}`; // Substitua pelo URL correto
      li.appendChild(link);
      fragment.appendChild(li);
    });
  }).
  then(() => {
    document.querySelector('ul').appendChild(fragment);
  }).
  catch(function(error) {
    console.log(error);
  });