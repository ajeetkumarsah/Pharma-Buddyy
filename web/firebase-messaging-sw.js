importScripts("https://www.gstatic.com/firebasejs/7.20.0/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/7.20.0/firebase-messaging.js");

firebase.initializeApp({
  apiKey: "AIzaSyCeaw_gVN0iQwFHyuF8pQ6PbVDmSVQw8AY",
  authDomain: "stackfood-bd3ee.firebaseapp.com",
  projectId: "stackfood-bd3ee",
  storageBucket: "stackfood-bd3ee.appspot.com",
  messagingSenderId: "1049699819506",
  appId: "1:1049699819506:web:a4b5e3bedc729aab89956b",
  databaseURL: "...",
});

const messaging = firebase.messaging();

// Optional:
messaging.onBackgroundMessage((message) => {
  console.log("onBackgroundMessage", message);
});