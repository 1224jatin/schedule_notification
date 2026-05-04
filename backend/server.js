const admin = require("firebase-admin");
const express = require("express");
const bodyParser = require("body-parser");
const cors = require("cors");

// Load the secret key
let serviceAccount;
if (process.env.FIREBASE_SERVICE_ACCOUNT) {
  try {
    serviceAccount = JSON.parse(process.env.FIREBASE_SERVICE_ACCOUNT);
  } catch (err) {
    console.error("Error parsing FIREBASE_SERVICE_ACCOUNT env var:", err);
    process.exit(1);
  }
} else {
  try {
    serviceAccount = require("./service-account.json");
  } catch (err) {
    console.error("service-account.json not found and FIREBASE_SERVICE_ACCOUNT env var is not set.");
    process.exit(1);
  }
}

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

const app = express();
app.use(cors());
app.use(bodyParser.json());

// Notification Route
app.post("/send-notification", async (req, res) => {
  try {
    const { token, title, body, data } = req.body;

    if (!token) {
      return res.status(400).send({ success: false, error: "Device token is required" });
    }

    const message = {
      notification: {
        title: title || "Parking Update",
        body: body || "Your session is active.",
      },
      data: data || {}, // Optional custom data
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

// Root route for health check
app.get("/", (req, res) => {
  res.send("FCM Notification Server is running.");
});

// Start Server
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
