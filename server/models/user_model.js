import mongoose from "mongoose";
const Schema = mongoose.Schema;

const userScheme = Schema({
    name : {
        type : String,
        required : true
    },
    email : {
        type : String,
        required : true,
        unique : true
    },
});

const User = mongoose.model("User", userScheme);

export default User;