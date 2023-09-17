import Express from "express";
const router = Express.Router();
import publicBook from "../models/public_book_model.js";
import auth from "../middleware/auth_middleware.js";

router.post("/publicbook/create", auth ,async (req, res) => {
  try {
    const { title, description, icon, pages, creator } = req.body;
    const newPublicBook = new publicBook({
      title,
      description,
      icon,
      pages,
      creator,
    });
    const public_book = await newPublicBook.save();
    res.status(200).json(public_book);
  } catch (error) {
    res.status(400).json({ msg: "Error creating public book" });
  }
});

router.get("/publicbook/:id/likes" ,async (req, res) => {
  try {
    const {id} = req.params;
    const public_book = await publicBook.findById(id);
    const likes = public_book.likes;
    res.status(200).json(likes);
  } catch (error) {
    res.status(400).json({ msg: "Error getting public books" });
  }
}
);

export default router;