# Consumo de Água 

Aplicação web responsiva desenvolvida para registrar e acompanhar o consumo de água, calculando automaticamente a meta diária e a porcentagem atingida de acordo com o peso corporal.

## 📌 Sobre o projeto

O projeto **Consumo de Água** foi desenvolvido como parte de um desafio de programação, com o objetivo de criar uma aplicação capaz de armazenar um histórico de consumo de água e calcular a porcentagem da meta diária atingida.

O sistema considera uma recomendação média de **35 ml de água por kg corporal**.

A meta diária é calculada utilizando a seguinte fórmula:

**Meta diária = 35 × peso corporal**

Exemplo:

* Peso: 60 kg
* Meta diária: `35 × 60 = 2100 ml`

Se a pessoa consumir 500 ml:

`500 ÷ 2100 × 100 = 23,8%`

Os registros são armazenados localmente no navegador utilizando **localStorage**.

## 🚀 Funcionalidades

* Cadastro de consumo de água
* Registro da data
* Registro da quantidade de água consumida
* Registro do peso atual
* Cálculo automático da meta diária
* Cálculo da porcentagem da meta atingida
* Exibição do total consumido no dia
* Exclusão de registros
* Edição dos registros através de um modal
* Persistência dos dados com `localStorage`
* Gráfico comparativo do consumo de água
* Tema escuro
* Interface responsiva para diferentes tamanhos de tela

## 🛠️ Tecnologias utilizadas

* HTML5
* CSS3
* JavaScript
* LocalStorage
* Chart.js

## 🧮 Cálculo da meta de água

A meta diária de consumo é estimada utilizando:

**Meta diária = 35 × peso**

Onde:

* **35** = recomendação média de ml de água por kg corporal
* **peso** = peso atual em kg

A porcentagem da meta atingida é calculada utilizando:

**Porcentagem = (quantidade consumida ÷ meta diária) × 100**

## 💾 Persistência de dados

Os registros são armazenados no navegador através do **LocalStorage**.

Isso permite que os registros de consumo continuem disponíveis mesmo depois de fechar e abrir novamente o navegador.

## 📊 Gráfico

A aplicação utiliza a biblioteca **Chart.js** para apresentar um gráfico comparativo entre o consumo de água registrado e a meta diária calculada.

## ▶️ Como executar

1. Clone ou baixe este repositório.
2. Abra a pasta do projeto.
3. Abra o arquivo `index.html` no navegador.

Não é necessário instalar servidor ou banco de dados.

## 📱 Responsividade

A interface foi desenvolvida para funcionar em:

* Computadores
* Notebooks
* Celulares
* Tablets
