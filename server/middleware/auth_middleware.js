import { jwtPasswordKey } from "../private.js";
import jwt from "jsonwebtoken";

// Auth Middleware
const auth = (req, res, next) => {
  // Get token from request
  const token = req.header("x-auth-token");
  // Check if token exists
  if (!token) {
    // Send error if token doesn't exist
    return res.status(401).json({ msg: "No token, authorization denied" });
  }
  try {
    // Verify token
    const decoded = jwt.verify(token, jwtPasswordKey);
    // Add user from payload
    req.user = decoded;
    // Continue
    next();
  } catch (err) {
    // Send error if token is invalid
    res.status(400).json({ msg: "Token is not valid" });
  }
};

export default auth;
