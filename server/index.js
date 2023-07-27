import AI  from "./hugging_face.mjs";
import express from "express";
AI("Why is my life so sad?").then(
    (response) => {
        console.log(response);
    }
);