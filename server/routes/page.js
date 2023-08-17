import auth from "../middleware/auth_middleware.js";
import Express from "express";
import Page from "../models/page_model.js";
import Book from "../models/book_model.js";

// Page router
const pageRouter = Express.Router();

// create a page
// POST /page/create headers: {x-auth-token}
// response body: {page} where page is just the encrypted strg
pageRouter.post("/page/create", auth, async (req, res) => {
  try {
    // encoded is the encrypted string
    const { encoded,bookId } = req.body;
    // create a new page
    const page = new Page({ encoded });
    // save the page
    const doc = await page.save();
    // add the page to the book
    Book.findByIdAndUpdate(bookId, { $push: { pages: doc._id } });
    // send the page
    res.status(200).json({ doc });
  } catch (error) {
    res.status(400).json({ msg: "Error creating page" });
  }
});

export default pageRouter;