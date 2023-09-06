import Express from "express";
import auth from "../middleware/auth_middleware.js";
import Book from "../models/book_model.js";
import User from "../models/user_model.js";
const bookRouter = Express.Router();

// Create book and add to user
// POST /book/create headers: {x-auth-token}
// Request body: {bookTitle, bookIcon, bookDescription}
// Response: {book}
bookRouter.post("/book/create", auth, async (req, res) => {
  try {
    const { bookTitle, bookIcon, bookDescription } = req.body;
    const newBook = new Book({
      title: bookTitle,
      icon: bookIcon,
      description: bookDescription,
    });
    const book = await newBook.save();
    // Add book to user
    const user = await User.findOneAndUpdate(
      { _id: req.user.id }, // Find user by id
      { $push: { books: book._id } }, // Add book to user
      { new: true }
    );
    // Send book
    res.status(200).json(book);
  } catch (error) {
    res.status(400).json({ msg: "Error creating book" });
  }
});

// Get all books
// GET /book/all headers: {x-auth-token}
// Response: [books]
bookRouter.get("/book/all", auth, async (req, res) => {
  try {
    // Get user
    const userId = req.user.id;
    const user = await User.findById(userId);
    // Get books
    const books = await Book.find({ _id: { $in: user.books } });
    // Send books
    res.status(200).json(books);
  } catch (error) {
    res.status(400).json({ msg: "Error getting books" });
  }
});

// UPDATE book
// POST /book/update headers: {x-auth-token}
// Request body: {bookId, bookTitle, bookIcon, bookDescription,password}
// Response: {book}
bookRouter.put("/book/update", auth, async (req, res) => {
  try {
    const { bookId, bookTitle, bookIcon, bookDescription, bookPassword } = req.body;
    const book = await Book.findByIdAndUpdate(
      bookId,
      {
        title: bookTitle,
        icon: bookIcon,
        description: bookDescription,
        password: bookPassword,
      },
      { new: true }
    );
    res.status(200).json(book);
  } catch (error) {
    res.status(400).json({ msg: "Error updating book" });
  }
});

// DELETE book
// DELETE /book/delete headers: {x-auth-token}
// Request body: {bookId}
// Response: {msg: "Book deleted"}
bookRouter.delete("/book/delete", auth, async (req, res) => {
  try {
    const { bookId } = req.body;
    await Book.findByIdAndDelete(bookId);
    res.status(200).json({ msg: "Book deleted" });
  } catch (error) {
    res.status(400).json({ msg: "Error deleting book" });
  }
});

export default bookRouter;
