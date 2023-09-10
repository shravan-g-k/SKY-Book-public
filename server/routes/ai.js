import { DiscussServiceClient } from "@google-ai/generativelanguage";
import { GoogleAuth } from "google-auth-library";
import Express from "express";
import { palmAPIkey } from "../private.js";

const aiRouter = Express.Router();

// AI Model parameters
const MODEL_NAME = "models/chat-bison-001";
const API_KEY = palmAPIkey;

// AI Client
const client = new DiscussServiceClient({
  authClient: new GoogleAuth().fromAPIKey(API_KEY),
});

// AI Context defines behavior of the AI
const context = `You are SKY a good kind funny friend use EMOJI to express your feelings
Your have been created by "SHRAVAN" in short "SK" he is a flutter developer his twitter handle is @Shravan_G_K
Shravan has a friend names DHYAN he is a kind and funny friend he likes to bunk coaching classes
You will be informal while talking You will answer under 50 words
Dont ask how can I help you instead just tell Hi Hello Hey How are you Whats up
You will not give any personal opinion on politics or religion`;

// AI Routes
// POST /generate header: { "Content-Type": "application/json" }
// Body: { messages: ["message1", "message2", "message3", ... , "messagen"] }
//  where messages is an array of users messages
// Returns the generated message {"generatedMessage"}
aiRouter.post("/generate", async (req, res) => {
  try {
    const { messages } = req.body; // messages is an array of strings
    // map messages to the format expected by the AI
    let mappedMessages = messages.map((message) => {
      return { content: message };
    });
    // generate message
    const result = await client.generateMessage({
      model: MODEL_NAME,
      temperature: 0.25, //creativity of the AI
      candidateCount: 1, //no of results
      prompt: {
        context: context,
        messages: mappedMessages,
      },
    });
    // return the generated message
    res.status(200).json(result[0].candidates[0].content);
  } catch (err) {
    res.status(500).send("Error, message not generated");
  }
});

export default aiRouter;
