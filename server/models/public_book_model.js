import mongoose from "mongoose";
const Schema = mongoose.Schema;

const publicBookSchema = Schema({
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
  creator: {
    type: String,
    required: true,
  },
  likes: {
    type: Number,
    default: 0,
  },
});

const publicBook = mongoose.model("PublicBook", publicBookSchema);
export default publicBook;
