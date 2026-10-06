importScripts(
  "https://www.gstatic.com/firebasejs/10.13.2/firebase-app-compat.js"
);
importScripts(
  "https://www.gstatic.com/firebasejs/10.13.2/firebase-messaging-compat.js"
);

firebase.initializeApp({
  apiKey: "AIzaSyAxy5hUpdmcMJ9MgNZo6wQzTrtfjwFQwkg",
  authDomain: "climapp-pkt.firebaseapp.com",
  projectId: "climapp-pkt",
  storageBucket: "climapp-pkt.firebasestorage.app",
  messagingSenderId: "870068188751",
  appId: "1:870068188751:web:ebc27017f6a713b38cdc3a",
});

const messaging = firebase.messaging();

messaging.onBackgroundMessage((payload) => {
  console.log("Mensagem recebida em segundo plano:", payload);
});