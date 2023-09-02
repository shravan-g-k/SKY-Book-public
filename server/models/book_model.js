import mongoose from "mongoose";
const Schema = mongoose.Schema;

const bookSchema = Schema({
  title: {
    type: String,
    required: true,
  },
  description: {
    type: String,
    required: true,
  },
  icon: {
    type: String,
    required: true,
    length: 1,
  },
  pages: [String],
  password: {
    type: String,
  }
});

const Book = mongoose.model("Book", bookSchema);
export default Book;
