import Express from "express";
import { PORT } from "./const.js";
import authRouter from "./routes/auth.js";
import bookRouter from "./routes/book.js";
import pageRouter from "./routes/page.js";
import aiRouter from "./routes/ai.js";
import publicBookRouter from "./routes/public_content.js";
import { mongoDBpassword } from "./private.js";
import mongoose from "mongoose";
import path from "path";
import { fileURLToPath } from "url";
const __dirname = path.dirname(fileURLToPath(import.meta.url));

// App initialization
const app = new Express();
// MongoDB connection
mongoose
  .connect(
      `mongodb+srv://skybook:${mongoDBpassword}@cluster0.9gj5u4u.mongodb.net/Production?retryWrites=true&w=majority`
  )
  .then(() => {
    console.log("Connected to MongoDB");
  })
  .catch((err) => {
    console.log(err);
  });

// Middleware
// JSON body parser
app.use(Express.json());
// Auth router - has the /signin /user
app.use(authRouter);
// Book router - has the /book/create /book/all /book/update
app.use(bookRouter);
// Page router - has the /page/create /pages /page/update
app.use(pageRouter);
// AI router - has the /generate
app.use(aiRouter);
// Public Book router - has the /publicbook/create
app.use(publicBookRouter);

// Start server
app.listen(PORT, "0.0.0.0", () => {
  console.log(`Server listening on port ${PORT}`);
});

app.get("/privacy-policy", (req, res) => {
  res.sendFile(__dirname + "/public/privacy_policy.html");
});
