import Express from "express";
import User from "../models/user_model.js";
import jwt from "jsonwebtoken";
import { jwtPasswordKey } from "../private.js";

// Auth Router
const authRouter = Express.Router();

// Signin route - creates a user if it doesn't exist, then returns the user and a token
// POST /signin body - { name, email }
// 200 - { user, token }
// 500 - Error, user not created
authRouter.post("/signin", async (req, res) => {
  try {
    // Get name and email from request body
    const { name, email } = req.body;
    // Check if user exists
    let user = await User.findOne({ email });
    // If user doesn't exist, create a new user
    if (!user) {
      user = new User({
        name,
        email,
      });
      // Save user to database if it doesn't exist
      user = await user.save();
    }
    // Create a token with the user's id
    const token = jwt.sign({ id: user._id }, jwtPasswordKey);
    // Send user and token as response
    res.status(200).json({ user, token });
  } catch (err) {
    // Send error if user not created
    res.status(500).send("Error, user not created");
  }
});

export default authRouter;
