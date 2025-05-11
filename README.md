# 💰 App de Controle de Ganhos por Atividade

## 📌 Descrição do Projeto

Este aplicativo Flutter permite que o usuário registre sua **carga horária de trabalho** e **salário mensal**, e posteriormente **registre atividades diárias** como pausas, redes sociais, entre outras. Com base nesses dados, o app calcula quanto o usuário efetivamente **ganha por mês**, considerando o tempo gasto em atividades fora do trabalho produtivo.

O objetivo é proporcionar **consciência financeira e de produtividade**, permitindo que o usuário tenha uma visão clara do impacto do uso do seu tempo no rendimento mensal.

---

## 👨‍💻 Autores

- Ricardo Cavalcante Soares

---

## 🛠️ Instruções de Instalação

1. **Clone o repositório:**

   ```bash
   git clone https://github.com/seu-usuario/seu-repositorio.git](https://github.com/4ric4/CagadaRemunerada.git
   cd seu-repositorio
   ```

2. **Instale as dependências do projeto:**

   ```bash
   flutter pub get
   ```

3. **Rode o app em modo debug (para testes):**

   ```bash
   flutter run
   ```

---

## 📦 Como gerar um APK no Flutter

1. **Certifique-se de que o ambiente está configurado corretamente:**

   ```bash
   flutter doctor
   ```

2. **Execute o comando para gerar o APK:**

   ```bash
   flutter build apk --release
   ```

3. O APK será gerado em:

   ```
   build/app/outputs/flutter-apk/app-release.apk
   ```

---

## 🧠 Funcionalidades Desenvolvidas

### 1. Registro de Carga Horária e Salário

- O usuário informa sua carga horária semanal (ex: 40h/semana) e seu salário bruto mensal.
- O sistema calcula automaticamente o valor ganho por minuto com base nesses dados.

### 2. Registro de Atividades Diárias

- O usuário pode registrar as atividades realizadas durante o dia, como:
  - Redes sociais
  - Café
  - Almoço
  - Pausas
  - Reuniões improdutivas
- Cada atividade é registrada com início, fim e categoria.

### 3. Cálculo de Ganhos Reais

- O app calcula quanto voce ganha nas pausas.
- 

### 4. Dashboard Resumido

- Visualizações rápidas com:
  - Tempo total trabalhado
  - Tempo de pausa
  - Ganhos estimados do mês
---

## 📱 Tecnologias Utilizadas

- Flutter
- SQLite (`sqflite`) para persistência local no mobile
- IndexedDB (`idb_shim`) para persistência no Flutter Web
- Internacionalização com `intl`
- UI responsiva com `BottomNavigationBar`
- Fonte personalizada Montserrat

---

## 📧 Contato

Para dúvidas ou sugestões: **ricardocavalcantecs@gmail.com**
