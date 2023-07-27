import {AI,AI2}  from "./hugging_face.mjs";
import express from "express";
// AI("Why is my life so sad?").then(
//     (response) => {
//         console.log(response);
//     }
// );
AI2("Do you know who is the prime minister of india").then(
    (response) => {
        console.log(response);
    }
);