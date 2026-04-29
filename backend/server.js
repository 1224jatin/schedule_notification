const admin = require("firebase-admin");
const express = require("express");
const bodyParser = require("body-parser");

// Load the secret key
const serviceAccount = require("./service-account.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

const app = express();
app.use(bodyParser.json());

// Notification Route
app.post("/send-notification", async (req, res) => {
  try {
    const { token, title, body } = req.body;

    const message = {
      notification: {
        title: title || "Parking Update",
        body: body || "Your session is active.",
      },
      token: token, 
    };

    const response = await admin.messaging().send(message);
    console.log("Notification sent successfully:", response);
    res.status(200).send({ success: true, messageId: response });
  } catch (error) {
    console.error("Error sending notification:", error);
    res.status(500).send({ success: false, error: error.message });
  }
});

// Start Server
const PORT = 3000;
app.listen(PORT, () => {
  console.log(`Server is running on http://localhost:${PORT}`);
});