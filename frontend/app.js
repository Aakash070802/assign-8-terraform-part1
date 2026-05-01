import dotenv from "dotenv";
dotenv.config();
import express from "express";
import fetch from "node-fetch";
import path from "path";
import { fileURLToPath } from "url";

const app = express();

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

app.use(express.static("public"));
app.use(express.urlencoded({ extended: true }));

app.set("view engine", "ejs");
app.set("views", path.join(__dirname, "views"));

const BACKEND_URL = process.env.BACKEND_URL;

app.get("/", (req, res) => {
  res.render("index");
});

app.post("/submit", async (req, res) => {
  try {
    const response = await fetch(BACKEND_URL, {
      method: "POST",
      headers: { "Content-Type": "application/x-www-form-urlencoded" },
      body: new URLSearchParams(req.body),
    });

    const result = await response.json();

    if (result.status === "success") {
      res.render("success", {
        name: result.name,
        email: result.email,
        phone: result.phone,
        city: result.city,
        message: result.message,
      });
    } else {
      res.send("Submission failed. Please try again.");
    }
  } catch (error) {
    console.error("ERROR:", error);
    return res.status(500).send("Internal Server Error");
  }
});

app.listen(3000, () => {
  console.log("Frontend running on port 3000");
});
