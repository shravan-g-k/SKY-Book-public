import mongoose from "mongoose";
const Schema = mongoose.Schema;

// User Schema (name, email,[books])
const userScheme = Schema({
    name : {
        type : String,
        required : true
    },
    email : {
        type : String,
        required : true,
    },
    books : [String],
});

// User Model Users Collection
const User = mongoose.model("User", userScheme);

export default User;