import AI  from "./hugging_face.mjs";
import express from "express";
AI("Write about gandhi in 10 words").then(
    (response) => {
        console.log(response);
    }
);