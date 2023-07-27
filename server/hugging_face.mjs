import { HfInference } from "@huggingface/inference";
import { HuggingFaceAPIkey } from "./private.js";
const hf = new HfInference(HuggingFaceAPIkey);

async function AI(data) {
  const wrap =
    "You are 'Helpful' and 'Kind' person You give answer to people with clear and motivating words.";

  for await (var output of hf.textGenerationStream({
    model: "OpenAssistant/oasst-sft-4-pythia-12b-epoch-3.5",
    inputs: wrap + data,
    parameters: { max_new_tokens: 500 },
  })) {
  }
  return output.generated_text;
}

async function AI2(data) {
  var output = await hf.conversational({
    model: "af1tang/personaGPT",
    inputs: {
      text: data,
      // past_user_inputs: [
      //   "Hi",
      //   "Myself chetu",
      //   "Whats your name",
      //   "Do you have any pets?",
      // ],
      // generated_responses: [
      //   "Hiya",
      //   "I'm a girl",
      //   "My name is samantha, what is yours? Do you have any pets?",
      // ],
    },
  });
  return output.generated_text;
}
export { AI, AI2 };
