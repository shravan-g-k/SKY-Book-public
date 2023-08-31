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
    const { encoded, bookId } = req.body;
    // create a new page
    const page = new Page({ encoded });
    // save the page
    const doc = await page.save();
    // add the page to the book
    await Book.findByIdAndUpdate(bookId, {
      $push: {
        pages: {
          $each: [doc._id],
          $position: 0,
        },
      },
    });
    // send the page
    res.status(200).json(doc);
  } catch (error) {
    res.status(400).json({ msg: "Error creating page" });
  }
});

// Get Pages from book
// GET /pages headers: {x-auth-token}
// additional headers: {bookid} | optional: {from} to get pages from a certain index
// Response: [pages] - first 30 pages by default or next 30 pages from the from index
pageRouter.get("/pages", auth, async (req, res) => {
  try {
    const { bookid, from } = req.headers;
    // Get book
    const book = await Book.findById(bookid);
    // Get all the pageIds from book
    var pageIds = book.pages;
    const pages = [];
    // Get the first 30 pages or next 30 pages from the from index
    if (from) {
      pageIds = pageIds.slice(from, from + 30); // 30 pages at a time
    } else {
      pageIds = pageIds.slice(0, 30); // 30 pages from the start by default
    }

    // Get all the pages from the specified pageIds
    Promise.all(
      // Iterate over all the pageIds and get the page Schema
      pageIds.map(async (pageId) => {
        const page = await Page.findById(pageId).then((page) => {
          pages.push(page); // Add the page to the pages array
        });
      })
    ).then(() => {
      pages.sort((a, b) => {
        return (
          pageIds.indexOf(a._id.toString()) - pageIds.indexOf(b._id.toString())
        );
      }); // Sort the pages according to the pageIds

      res.status(200).json(pages); // Send the pages
    });
  } catch (error) {
    console.log(error);
    res.status(400).json({ msg: "Error getting pages" });
  }
});

// Update a page
// PUT /page/update headers: {x-auth-token}
// request body: {pageId, encoded}
// response body: {page} where page is the updated page
pageRouter.put("/page/update", auth, async (req, res) => {
  try {
    const { pageId, encoded } = req.body;// Get the pageId and the encoded string
    const page = await  Page.findByIdAndUpdate(pageId, { encoded }, { new: true });// Update the page with the new encoded string and return the updated page
    res.status(200).json(page);// Send the updated page
  } catch (error) {
    res.status(400).json({ msg: "Error updating page" });
  }
});

pageRouter.delete("/page/delete", auth, async (req, res) => {
  try {
    const { pageId, bookId } = req.body;
    // Delete the page
    const page = await Page.findByIdAndDelete(pageId);
    // Remove the page from the book
    const book  = await Book.findByIdAndUpdate(bookId, {
      $pull: {
        pages: pageId,
      },
    });
    res.status(200).json(page);
  } catch (error) {
    res.status(400).json({ msg: "Error deleting page" });
  }
});

export default pageRouter;
