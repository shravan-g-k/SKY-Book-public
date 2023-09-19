import Express from "express";
import User from "../models/user_model.js";
import jwt from "jsonwebtoken";
import auth from "../middleware/auth_middleware.js";
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
    console.log(err);
    // Send error if user not created
    res.status(500).send("Error, user not created");
  }
});

// Get user route - returns a user if it exists
// GET /user
// 200 - { name , email , _id }
// 500 - Error, user not found
authRouter.get("/user", auth,  async (req, res) => {
  try {
    // Get user id from request
    const { id } = req.user;
    // Find user by id
    let user = await User.findById(id);
    // Send user as response
    res.status(200).json(user);
  } catch (err) {
    // Send error if user not found
    res.status(500).send("Error, user not found");
  }
});

export default authRouter;
