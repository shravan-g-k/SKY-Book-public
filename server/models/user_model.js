import mongoose from "mongoose";
const Schema = mongoose.Schema;

// User Schema (name, email)
const userScheme = Schema({
    name : {
        type : String,
        required : true
    },
    email : {
        type : String,
        required : true,
    },
});

// User Model Users Collection
const User = mongoose.model("User", userScheme);

export default User;