const admin = require("firebase-admin");
const express = require("express");
const app = express();
app.use(express.json());

// Import the service account key
const serviceAccount = require("./parkingexpense-firebase-adminsdk-fbsvc-c02fbf139b.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

app.post("/send-notification", (req, res) => {
  const { token, title, body } = req.body;

  const message = {
    notification: {
      title: title || "Default Title",
      body: body || "Default Body",
    },
    token: token,
  };

  admin.messaging().send(message)
    .then((response) => {
      console.log("Successfully sent message:", response);
      res.status(200).send({ success: true, response });
    })
    .catch((error) => {
      console.log("Error sending message:", error);
      res.status(500).send({ success: false, error });
    });
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
