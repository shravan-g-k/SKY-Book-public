import Express from "express";
import auth from "../middleware/auth_middleware.js";
import Book from "../models/book_model.js";
import User from "../models/user_model.js";
const bookRouter = Express.Router();

// Create book and add to user
// POST /book/create headers: {x-auth-token}
// Request body: {bookTitle, bookIcon, bookDescription}
// Response: {book}
bookRouter.post("/book/create" ,auth,async (req, res) => {
    try {
        const {bookTitle, bookIcon, bookDescription} = req.body;
        console.log(req.body);
        const newBook = new Book({
            title : bookTitle,
            icon : bookIcon,
            description : bookDescription
        });
        const book = await newBook.save();
        // Add book to user
        const user = await User.findOneAndUpdate(
            {_id : req.user.id},// Find user by id
            {$push : {books : book._id}},// Add book to user
            {new : true}
        );
        // Send book
        res.status(200).json(book);
    } catch (error) {
        console.log(error);
        res.status(400).json({msg : "Error creating book"});
    }
});


export default bookRouter;