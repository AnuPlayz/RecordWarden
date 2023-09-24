import { ethers } from "hardhat";

const wait = (ms: number) => new Promise(r => setTimeout(r, ms))

async function main() {
  const us = "0xc9B0b0075CC479B277f721C76dAca7A9adc3f023"

  const RecordWarden = await ethers.deployContract("RecordWarden");
  await RecordWarden.waitForDeployment();
  await wait(3000)

  let addr = await RecordWarden.getAddress()
  await wait(3000)
  console.log(`Deployed at: ${addr}`)

  console.log("Giving Lawyer & Judge Role to admin")
  await RecordWarden.grantLawyerRole(us)
  await RecordWarden.grantJudgeRole(us)
  await wait(3000)
  console.log("ok now we have lawyer role, we make a case now")

  let meow = await RecordWarden.createCase("ur mom is a case", us)
  await wait(3000)
  console.log("Case has been created")
  
  console.log("Adding document")
  await RecordWarden.addDocument(1, "Meow", "meow meow", "ipfs://data", true)
  await wait(3000)
  console.log("Added Document")
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
