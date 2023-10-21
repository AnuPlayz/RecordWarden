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

/**
 * Deploys the RecordWarden contract, grants lawyer role to an admin, creates a case for Ani,
 * adds evidence to the case and logs the case details.
 */
async function main() {
  const admin = "0xc9B0b0075CC479B277f721C76dAca7A9adc3f023"

  const RecordWarden = await ethers.deployContract("RecordWarden");
  await RecordWarden.waitForDeployment();
  await wait(3000)

  let addr = await RecordWarden.getAddress()
  console.log("RecordWarden deployed to:", addr);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
