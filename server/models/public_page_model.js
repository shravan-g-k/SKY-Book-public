import mongoose from "mongoose";
const Schema = mongoose.Schema;

const publicBookSchema = Schema({
  title: {
    type: String,
    required: true,
  },
  data : {
    type: String,
    required: true,
  },
  icon: {
    type: String,
    required: true,
    length: 1,
  },
  creator: {
    type: String,
    required: true,
  },
  likes: {
    type: Number,
    default: 0,
  },
});

const publicPage = mongoose.model("PublicPage", publicBookSchema);
export default publicPage;
