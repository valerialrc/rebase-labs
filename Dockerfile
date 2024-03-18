FROM ruby

# Instalação de dependências para o Chrome e ChromeDriver
RUN apt-get update && apt-get install -y wget gnupg2 unzip

# Instala o Google Chrome
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list' \
    && apt-get update && apt-get install -y google-chrome-stable

# Instala o Selenium WebDriver
RUN gem install selenium-webdriver

# Define o diretório de trabalho
WORKDIR /app

RUN chown -R $USER:$USER .