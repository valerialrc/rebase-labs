function fetchDataAndRender() {
  const fragment = document.createDocumentFragment();
  const url = 'http://localhost:3000/tests';

  fetch(url)
      .then(response => response.json())
      .then(data => {
          const uniqueTokens = new Set(data.map(test => test.result_token));
          const listDiv = document.getElementById('test-list');
          const ul = document.createElement('ul');

          uniqueTokens.forEach(token => {
              const li = document.createElement('li');
              const link = document.createElement('a');
              link.textContent = token;
              link.href = `#tests/${token}`;
              link.onclick = handleLinkClick;
              li.appendChild(link);
              ul.appendChild(li);
          });

          listDiv.appendChild(ul);
      })
      .catch(error => console.error(error));
}

function handleLinkClick(event) {
  event.preventDefault();
  const token = event.target.textContent;
  renderTestDetails(token);
}

function renderTestDetails(token) {
  const url = `http://localhost:3000/tests/${token}`;

  fetch(url)
    .then(response => response.json())
    .then(data => {
      const detailsDiv = document.getElementById('test-details');
      detailsDiv.innerHTML = '';

      const title = document.createElement('h2');
      title.textContent = `Resultado do exame ${token}`;
      detailsDiv.appendChild(title);

      const detailsList = document.createElement('ul');

      const commonDetails = ['patient_name', 'patient_cpf', 'patient_email',
                             'patient_birthdate', 'patient_address', 'patient_city',
                             'patient_state', 'exam_date'];
      commonDetails.forEach(key => {
          const listItem = document.createElement('li');
          listItem.innerHTML = `<strong>${key.replace('_', ' ').toUpperCase()}:</strong> ${data[key]}`;
          detailsList.appendChild(listItem);
      });

      const doctorDetails = ['doctor_crm', 'doctor_crm_state', 'doctor_name']
      doctorDetails.forEach(key => {
        const listItem = document.createElement('li');
        listItem.innerHTML = `<strong>${key.replace(/_/g, ' ').toUpperCase()}:</strong> ${data['doctor'][key]}`;
        detailsList.appendChild(listItem);
      });

      data['tests'].forEach(test => {
        const card = document.createElement('div');
        card.classList.add('card');

        const detailsExam = document.createElement('ul');

        const testDetails = ['type', 'limits', 'result']
        testDetails.forEach(key => {
          const listItem = document.createElement('li');
          listItem.innerHTML = `<strong>${key.replace('_', ' ').toUpperCase()}:</strong> ${test[key]}`;
          detailsExam.appendChild(listItem);
        });

        card.appendChild(detailsExam);
        detailsList.appendChild(card);
      })

      const backButton = document.createElement('button');
      backButton.textContent = 'Voltar';
      backButton.addEventListener('click', () => {
          document.getElementById('test-list').style.display = 'block';
          detailsDiv.style.display = 'none';
      });

      detailsDiv.appendChild(backButton);
      detailsDiv.appendChild(detailsList);
      document.getElementById('test-list').style.display = 'none';
      document.getElementById('test-details').style.display = 'block';
    })
    .catch(error => console.error(error));
}

document.addEventListener('DOMContentLoaded', function() {
  const searchForm = document.getElementById('test-form');
  searchForm.addEventListener('submit', function(event) {
    event.preventDefault();

    const tokenInput = document.getElementById('token').value;
    if (!tokenInput) {
        alert('Por favor, insira um token válido.');
        return;
    }
    renderTestDetails(tokenInput);
  });
});

document.getElementById('csv-form').addEventListener('submit', function(event) {
  event.preventDefault();
  
  const fileInput = document.getElementById('csv-file');
  const file = fileInput.files[0];
  
  const formData = new FormData();
  formData.append('csv_file', file);

  fetch('/import', {
    method: 'POST',
    body: formData
  })
  .then(response => {
    if (response.ok) {
      return response.text();
    } else {
      console.log(response)
      return response.text();
    }
  })
  .then(importResponse => {
    const responseElement = document.createElement('p');
    responseElement.textContent = importResponse;
    document.getElementById('response-container').appendChild(responseElement);
    console.log('Upload do CSV realizado com sucesso!');
  })
  .catch(error => console.error('Erro ao fazer upload do CSV:', error));
});

window.onload = fetchDataAndRender;
