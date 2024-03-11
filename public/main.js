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
                             'patient_state', 'doctor_crm', 'doctor_crm_state',
                             'doctor_name', 'doctor_email', 'exam_date'];
      commonDetails.forEach(key => {
          const listItem = document.createElement('li');
          listItem.innerHTML = `<strong>${key.replace('_', ' ').toUpperCase()}:</strong> ${data[0][key]}`;
          detailsList.appendChild(listItem);
      });

      data.forEach(test => {
        const card = document.createElement('div');
        card.classList.add('card');

        const detailsExam = document.createElement('ul');

        const examTypes = Object.keys(test).filter(key => key.startsWith('exam_') && key !== 'exam_date');
        examTypes.forEach(type => {
          const listItem = document.createElement('li');
          listItem.innerHTML = `<strong>${type.replace('exam_', '').toUpperCase()}:</strong> ${test[type]}`;
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

window.onload = fetchDataAndRender;
