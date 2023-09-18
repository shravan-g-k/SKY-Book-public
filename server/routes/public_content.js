import Express from "express";
const router = Express.Router();
import publicBook from "../models/public_book_model.js";
import publicPage from "../models/public_page_model.js";
import auth from "../middleware/auth_middleware.js";

router.post("/publicbook/create", auth, async (req, res) => {
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

router.post("/publicpage/create", auth, async (req, res) => {
  try {
    const { title, data, icon, creator } = req.body;
    const newPublicPage = new publicPage({
      title,
      data,
      icon,
      creator,
    });
    const public_page = await newPublicPage.save();
    console.log(public_page);
    res.status(200).json(public_page);
  } catch (error) {
    res.status(400).json({ msg: "Error creating public page" });
  }
});

router.get("/publicpage/:id/likes", async (req, res) => {
  try {
    const { id } = req.params;
    const public_page = await publicPage.findById(id);
    const likes = public_page.likes;
    res.status(200).json(likes);
  } catch (error) {
    res.status(400).json({ msg: "Error getting page likes" });
  }
});
router.get("/publicbook/:id/likes", async (req, res) => {
  try {
    const { id } = req.params;
    const public_book = await publicBook.findById(id);
    const likes = public_book.likes;
    res.status(200).json(likes);
  } catch (error) {
    res.status(400).json({ msg: "Error getting public books" });
  }
});

router.put("/publicpage/:id/likes", auth, async (req, res) => {
  try {
    const { id } = req.params;
    const public_page = await publicPage.findById(id);
    public_page.likes = public_page.likes + 1;
    const updated_public_page = await public_page.save();
    res.status(200).json(updated_public_page);
  } catch (error) {
    res.status(400).json({ msg: "Error getting public books" });
  }
});

router.put("/publicbook/:id/likes", auth, async (req, res) => {
  try {
    const { id } = req.params;
    const public_book = await publicBook.findById(id);
    public_book.likes = public_book.likes + 1;
    const updated_public_book = await public_book.save();
    res.status(200).json(updated_public_book);
  } catch (error) {
    res.status(400).json({ msg: "Error getting public books" });
  }
});

router.get("/publicbook", async (req, res) => {
  try {
    var { next } = req.header;
    if (!next) {
      next = 0;
    }
    const public_books = await publicBook
      .find()
      .sort({ _id: 1 })
      .skip(next)
      .limit(30);
    res.status(200).json(public_books);
  } catch (error) {
    console.log(error);
    res.status(400).json({ msg: "Error getting public books" });
  }
});

router.get("/publicpage", async (req, res) => {
  try {
    var { next } = req.header;
    if (!next) {
      next = 0;
    }
    const public_pages = await publicPage
      .find()
      .sort({ _id: 1 })
      .skip(next)
      .limit(30);
    res.status(200).json(public_pages);
  } catch (error) {
    res.status(400).json({ msg: "Error getting public pages" });
  }
});

export default router;
