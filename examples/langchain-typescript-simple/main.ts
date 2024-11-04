import { Unieai } from 'langchain/llms/unieai';
import * as readline from "readline";

async function main() {
  const unieai = new Unieai({
    model: 'mistral'
    // other parameters can be found at https://js.langchain.com/docs/api/llms_unieai/classes/Unieai
  });

  const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout,
  });

  rl.question("What is your question: \n", async (user_input) => {
    const stream = await unieai.stream(user_input);

    for await (const chunk of stream) {
      process.stdout.write(chunk);
    }
    rl.close();
  })
}

main();