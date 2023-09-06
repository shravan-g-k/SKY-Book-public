import mongoose from "mongoose";
const Schema = mongoose.Schema;

const pageSchema = new Schema({
  encoded: {
    type: String,
    required: true,
  },
});

const Page = mongoose.model("Page", pageSchema);

export default Page;