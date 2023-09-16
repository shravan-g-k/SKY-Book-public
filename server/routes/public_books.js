import Express from "express";
const router = Express.Router();
import publicBook from "../models/public_book_model.js";
import auth from "../middleware/auth_middleware.js";

router.post("/publicbook/create", auth ,async (req, res) => {
  try {
    const { title, description, icon, pages } = req.body;
    const newPublicBook = new publicBook({
      title,
      description,
      icon,
      pages,
    });
    console.log(newPublicBook);
    const public_book = await newPublicBook.save();
    res.status(200).json(public_book);
  } catch (error) {
    console.log(error);
    res.status(400).json({ msg: "Error creating public book" });
  }
});

export default router;