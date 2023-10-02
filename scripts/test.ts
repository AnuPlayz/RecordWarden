import { ethers } from "hardhat";

const wait = (ms: number) => new Promise(r => setTimeout(r, ms))

const initalData = [
  {
    "description": "A copyright infringement case against a website for using unauthorized images. The plaintiff is a photographer.",
  },
  {
    "description": "A trademark infringement case against a company for using a similar logo. The plaintiff is a clothing brand.",
  },
  {
    "description": "A patent infringement case against a company for using a patented invention. The plaintiff is a biotech company.",
  },
  {
    "description": "A contract dispute case between two companies over the terms of a contract. The plaintiff is a software company.",
  },
  {
    "description": "A personal injury case against a company for negligence. The plaintiff is a construction worker.",
  }
]

async function main() {
  const admin = "0xc9B0b0075CC479B277f721C76dAca7A9adc3f023"

  const Test = await ethers.deployContract("Test");
  await Test.waitForDeployment();
  await wait(3000)

  let addr = await Test.getAddress()
  console.log("Test deployed to:", addr);

  await Test.createCase();
  await wait(3000)

  console.log("Fetching case...")
  //console.log(await Test.cases(1))

  console.log("Adding lawyer")
  let adding = await Test.addLawyer(1, admin);
  await adding.wait()

  console.log("Fetching lawyers...")
  let c = await Test.fetchLawyers(1)
  console.log(c)

  console.log("Sexing the new lawyer")
  await Test.removeThatBastard(1, admin)
  console.log("That bastard removed from life")

  console.log("Fetching lawyers...")
  let x = await Test.fetchLawyers(1)
  console.log(x)
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
}
