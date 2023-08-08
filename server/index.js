import Express from "express";
import { PORT } from "./const.js";
import authRouter from "./routes/auth.js";
import bookRouter from "./routes/book.js";
import { mongoDBpassword } from "./private.js";
import mongoose from "mongoose";

// App initialization
const app = new Express();
// MongoDB connection
mongoose
  .connect(
    `mongodb+srv://sk:${mongoDBpassword}@journalbot.vjrj3zu.mongodb.net/?retryWrites=true&w=majority`
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
// Book router - has the /book/create 
app.use(bookRouter);

// Start server
app.listen(PORT, "0.0.0.0", () => {
  console.log(`Server listening on port ${PORT}`);
});
