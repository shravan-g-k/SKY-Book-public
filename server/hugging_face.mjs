import { HfInference } from "@huggingface/inference";
import { HuggingFaceAPIkey } from "./private.js";
const hf = new HfInference(HuggingFaceAPIkey);

async function AI(data) {
  const wrap = "You are a writing assistant who helps people write articles and journals your duty is to provide the user with a simple crisp and clear answer" ;

  for await (var output of hf.textGenerationStream({
    model: "OpenAssistant/oasst-sft-4-pythia-12b-epoch-3.5",
    inputs:  (wrap + data),
    parameters: { max_new_tokens: 500 },
  })) {  }
  return output.generated_text
}
export default AI;
